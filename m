Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbZKJP24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbZKJP24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 10:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756600AbZKJP2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 10:28:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756428AbZKJP2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 10:28:54 -0500
From: Steve Grubb <sgrubb@redhat.com>
Organization: Red Hat
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: drop SECURITY_FILE_CAPABILITIES?
Date: Tue, 10 Nov 2009 10:28:10 -0500
User-Agent: KMail/1.12.2 (Linux/2.6.30.9-96.fc11.x86_64; KDE/4.3.2; x86_64; ; )
Cc: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       Andrew Morgan <morgan@kernel.org>, Kees Cook <kees.cook@canonical.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       George Wilson <gcwilson@us.ibm.com>
References: <20091110140739.GA15534@us.ibm.com>
In-Reply-To: <20091110140739.GA15534@us.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911101028.10797.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 November 2009 09:07:39 am Serge E. Hallyn wrote:
> I think that's the case most users will care about, whereas the
> remaining differences between CONFIG_SECURITY_FILE_CAPABILITIES=y
> and =n are that with CONFIG_SECURITY_FILE_CAPABILITIES=y :
> 
> 	(1) certain security hooks (task_setscheduler, task_setioprio, and
> 	task_setnice) do capability set comparisions,
> 	(2) it is possible to drop capabilities from the bounding set,
> 	(3) it is possible to set per-task securelevels,
> 	(4) and it is possible to add any capability to your inheritable
> 	set if you have CAP_SETPCAP.
> 
> Does anyone know of cases where CONFIG_SECURITY_FILE_CAPABILITIES=n
> is still perceived as useful?

As a library writer, I wished that the kernel behavior was either consistent, 
or there is an API that I can use to find out what model we are operating 
under. The biggest issue is that for a distribution we know the assumptions 
the distribution should be running under. But end users are free to build 
their own kernel that has it disabled. This has already lead to dbus not 
working at all.

I also take issue with probing the capability version number returning EINVAL 
when its the only way to find out what the preferred version is.

-Steve
