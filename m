Return-Path: <linux-kernel-owner+w=401wt.eu-S1161786AbXEBVYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161786AbXEBVYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161790AbXEBVYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:24:36 -0400
Received: from terminus.zytor.com ([192.83.249.54]:54559 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161786AbXEBVYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:24:35 -0400
Message-ID: <46390185.30900@zytor.com>
Date: Wed, 02 May 2007 14:24:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Gerd Hoffmann <kraxel@redhat.com>,
       Jeff Garzik <jeff@garzik.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@in.ibm.com>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <20070428758.455116000@suse.de>	<20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>	<m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4634483E.9030307@goop.org>	<m14pmz8bbb.fsf@ebiederm.dsl.xmission.com> <46363A68.6080201@goop.org>	<46385A8A.6070405@redhat.com> <4638AB55.20408@goop.org>	<4638F9BE.8090508@zytor.com> <m13b2fvsbn.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m13b2fvsbn.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> So we won't do this casually and if it there are real problems we will
> remove the ELF magic number.
> 

I think we can use ELF-compatible format just fine, but it would make
more sense to use a non-ELF magic number from the start, instead of
signalling it with a note.  Since bootloaders need to be aware, anyway,
they can just detect this magic and treat is as an Linux calling
convention ELF image, or they can not detect it, and treat it as a
bzImage.  As a side benefit, we:

a) can use a magic number that contains a jump instruction (to keep the
non-bootsector happy);
b) get a proper Linux kernel magic number.

	-hpa
