Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbYJLTjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbYJLTjy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 15:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbYJLTjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 15:39:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34228 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbYJLTjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 15:39:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andy Wettstein <ajw1980@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Pavel Machek <pavel@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [REGRESSION] Re: [Bug 11568] spontaneous reboot on resume with 2.6.27
Date: Sun, 12 Oct 2008 21:44:02 +0200
User-Agent: KMail/1.9.9
Cc: bugme-daemon@bugzilla.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20081012192513.3D3F111D107@picon.linux-foundation.org>
In-Reply-To: <20081012192513.3D3F111D107@picon.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810122144.02897.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 12 of October 2008, bugme-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=11568
> 
> 
> 
> 
> 
> ------- Comment #27 from ajw1980@gmail.com  2008-10-12 12:25 -------
> SMP enabled with patch from #24 does not abort the suspend, and of course
> reboots on resume.

Andy, thanks for testing.

Ingo, Peter, Pavel,

The regression here is that x86_64 non-SMP systems using SMP kernel fail to
resume from suspend to RAM, most probably due to the trampoline code being
busted.  I haven't found anything obviously wrong in the code yet, but I
suspect that something simply writes over the (original) trampoline code.

This is in 2.6.27 as well as in the current mainline and it's quite urgent,
because we'll get hit by it in distro kernels based on 2.6.27 if we don't fix
it timely. 

Please have a look at bug #11568.

Thanks,
Rafael
