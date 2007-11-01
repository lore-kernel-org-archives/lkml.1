Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbXKARLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbXKARLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 13:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757222AbXKARLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 13:11:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281AbXKARLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 13:11:38 -0400
Message-ID: <472A08F9.8060605@redhat.com>
Date: Thu, 01 Nov 2007 15:12:25 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070811)
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       akpm@linux-foundation.org, travis@sgi.com
Subject: Re: [PATCH] x86: show cpuinfo only for online CPUs
References: <20071101170206.GA7820@alberich.amd.com>
In-Reply-To: <20071101170206.GA7820@alberich.amd.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andreas Herrmann escreveu:
> This patch applies on current Linus' git with Glauber's recent cpuinfo fix
> (http://marc.info/?l=linux-kernel&m=119392088227245) applied.
> 
> 
> Regards,
> 
> Andreas
> 

Andreas,

did you test it in a kernel without SMP compiled in ?

I'm a little afraid about what can happen here:

- --- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -998,7 +998,7 @@ void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 static int show_cpuinfo(struct seq_file *m, void *v)
 {
 	struct cpuinfo_x86 *c = v;
- -	int cpu = 0;
+	int cpu = c->cpu_index;

The attribuition of cpu_index only happens in a code that seems to be
called for all cpus but the boot one.

So it could even work, but as accident. Unless I'm wrong about it, I'd
prefer to see an explicit attribution of cpu_index = 0 somewhere for the
boot cpu.

Other than that, good catch! I didn't notice it, because all my present
cpus were online in my box
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Remi - http://enigmail.mozdev.org

iD8DBQFHKgj5jYI8LaFUWXMRAsU1AJ4ixYO42zHGK3Kx5SXH+cdly/rZ6wCfX6Kh
q2OCPt2qTniPmMNz+MzXc60=
=mYoV
-----END PGP SIGNATURE-----
