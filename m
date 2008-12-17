Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752449AbYLQTeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbYLQTeR (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbYLQTd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:33:59 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50278 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbYLQTd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:33:57 -0500
Date: Wed, 17 Dec 2008 14:31:51 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: initramfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
        Dave Jones <davej@redhat.com>, cjwatson@ubuntu.com
Subject: Re: Dracut -- Cross distribution initramfs infrastructure
Message-ID: <20081217193151.GA7356@hmsreliant.think-freely.org>
References: <1229540094.28858.150.camel@aglarond.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229540094.28858.150.camel@aglarond.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 01:54:54PM -0500, Jeremy Katz wrote:
> As davej started talking about a few months ago at Kernel Summit and
> LPC, there's a lot of duplication between distros on the tools used to
> generate the initramfs as well as the contents and how the initramfs
> works.  Ultimately, there's little reason for this not to be something
> that is shared and worked on by everyone.  Added to this is the fact
> that everyone's infrastructures for this have grown up over a long-ish
> period of time without significant amounts of reworking for the way that
> the kernel and early boot works these days.
> 
> Therefore I've started on a new project, dracut, to try to be a new
> initramfs tool that can be used across various distributions.  From the
> README...
> 
> Unlike existing initramfs's, this is an attempt at having as little as
> possible hard-coded into the initramfs as possible.  The initramfs has
> (basically) one purpose in life -- getting the rootfs mounted so that we
> can transition to the real rootfs.  This is all driven off of device
> availability.  Therefore, instead of scripts hard-coded to do various
> things, we depend on udev to create device nodes for us and then when we
> have the rootfs's device node, we mount and carry on. This helps to keep
> the time required in the initramfs as little as possible so that things
> like a 5 second boot aren't made impossible as a result of the very
> existence of an initramfs.  It's likely that we'll grow some hooks for
> running arbitrary commands in the flow of the script, but it's worth
> trying to resist the urge as much as we can as hooks are guaranteed to
> be the path to slow-down.
> 
> Also, there is an attempt to keep things as distribution-agnostic as
> possible.  Every distribution has their own tool here and it's not
> something which is really interesting to have separate across them. So
> contributions to help decrease the distro-dependencies are welcome.
> 
> The git tree can be found at git://fedorapeople.org/~katzj/dracut.git
> for now.  See the TODO file for things which still need to be done and
> HACKING for some instructions on how to get started using the tool.
> There is also a mailing list that is being used for the discussion --
> initramfs@vger.kernel.org.  
> 
> Currently, there are a few Fedora-isms which have crept in just as a
> result of it being the shortest path to solving some problems, but I'm
> actively trying to get those out sooner rather than later as well as
> getting to where I'm using it to boot my laptop.
> 
> Comments and discussion welcome
> 
> Jeremy
> 

Not that I don't think a unifying tool to create an initramfs is a bad idea
(quite the contrary, I think it would be great), but I'd like to point out that
one of your underlying premises is a bit shaky.  That an initramfs has one
purpose, that being to get the rootfs mounted, isn't entirely accurate.  Kdump
and various embedded systems being the prime examples here.  Many embedded
systems run entirely out of the initramfs, and contain all the code they need to
do so in them.  Additionally, kdump in most environments, attemps to capture
core files entirely from the initramfs as well, operating under the assumption
that the rootfs may not be functioning properly after a crash.  By and large
these initramfs images tend to be larger and offer a more typical (if not
standard) user operating environment.  I'm looking at your tree now, and it
looks like a good start on standardizing the initramfs for the nominal case.  Do
you have plans to include (or are you interested in including) support for
alternate infrastructure (like busybox instead of nash), interactive setup, etc?

Regards
Neil
 
-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
