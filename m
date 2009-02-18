Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbZBRSex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbZBRSex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 13:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756445AbZBRSee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 13:34:34 -0500
Received: from testure.choralone.org ([194.9.77.134]:58210 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469AbZBRSed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:34:33 -0500
Date: Wed, 18 Feb 2009 13:34:27 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH] cpufreq: Change link order of x86 cpufreq modules
Message-ID: <20090218183427.GD25343@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
	linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
References: <20090218182822.GA19902@srcf.ucam.org> <20090218183137.GD26802@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218183137.GD26802@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 07:31:37PM +0100, Ingo Molnar wrote:
 > 
 > * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
 > 
 > > Change the link order of the cpufreq modules to ensure that they're 
 > > probed in the preferred order when statically linked in.
 > >     
 > > Signed-off-by: Matthew Garrett <mjg@redhat.com>
 > > 
 > > diff --git a/arch/x86/kernel/cpu/cpufreq/Makefile b/arch/x86/kernel/cpu/cpufreq/Makefile
 > > index 560f776..509296d 100644
 > > --- a/arch/x86/kernel/cpu/cpufreq/Makefile
 > > +++ b/arch/x86/kernel/cpu/cpufreq/Makefile
 > > @@ -1,6 +1,11 @@
 > > +# Link order matters. K8 is preferred to ACPI because of firmware bugs in early
 > > +# K8 systems. ACPI is preferred to all other hardware-specific drivers.
 > > +# speedstep-* is preferred over p4-clockmod.
 > 
 > Nice fix! Where does this information come from? Distro module 
 > ordering magic? It's rather non-trivial.

it's a mess of shell script right now.
See /etc/init.d/cpuspeed on Fedora for eg. 

 > (small style nit: the first line in the Makefile is overlong.)
 
I'll fix that up before merging.

Thanks Matthew, queued for .30

	Dave 


-- 
http://www.codemonkey.org.uk
