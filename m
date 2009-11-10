Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbZKJPyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbZKJPyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 10:54:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756692AbZKJPyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 10:54:13 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:40503 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263AbZKJPyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 10:54:12 -0500
Date: Tue, 10 Nov 2009 09:53:49 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       Andrew Morgan <morgan@kernel.org>, Kees Cook <kees.cook@canonical.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       George Wilson <gcwilson@us.ibm.com>, KaiGai Kohei <kaigai@kaigai.gr.jp>
Subject: Re: drop SECURITY_FILE_CAPABILITIES?
Message-ID: <20091110155349.GA18185@us.ibm.com>
References: <20091110140739.GA15534@us.ibm.com>
 <200911101028.10797.sgrubb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911101028.10797.sgrubb@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Steve Grubb (sgrubb@redhat.com):
> On Tuesday 10 November 2009 09:07:39 am Serge E. Hallyn wrote:
> > I think that's the case most users will care about, whereas the
> > remaining differences between CONFIG_SECURITY_FILE_CAPABILITIES=y
> > and =n are that with CONFIG_SECURITY_FILE_CAPABILITIES=y :
> > 
> > 	(1) certain security hooks (task_setscheduler, task_setioprio, and
> > 	task_setnice) do capability set comparisions,
> > 	(2) it is possible to drop capabilities from the bounding set,
> > 	(3) it is possible to set per-task securelevels,
> > 	(4) and it is possible to add any capability to your inheritable
> > 	set if you have CAP_SETPCAP.
> > 
> > Does anyone know of cases where CONFIG_SECURITY_FILE_CAPABILITIES=n
> > is still perceived as useful?
> 
> As a library writer, I wished that the kernel behavior was either consistent, 
> or there is an API that I can use to find out what model we are operating 
> under. The biggest issue is that for a distribution we know the assumptions 
> the distribution should be running under. But end users are free to build 
> their own kernel that has it disabled. This has already lead to dbus not 
> working at all.
> 
> I also take issue with probing the capability version number returning EINVAL 
> when its the only way to find out what the preferred version is.

In 2007/2008, KaiGai had floated patches to export capability info
over securityfs.  If it was something library writers and distros
wanted, we could resurrect those patches - and tack on some info
about cap-related kernel config.

-serge
