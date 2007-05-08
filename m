Return-Path: <linux-kernel-owner+w=401wt.eu-S966840AbXEHRZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966840AbXEHRZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 13:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966289AbXEHRZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 13:25:06 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34144 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966331AbXEHRZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 13:25:05 -0400
Date: Tue, 8 May 2007 22:54:49 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: yhlu <yhlu.kernel@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Gerd Hoffmann <kraxel@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
Message-ID: <20070508172449.GA1932@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <46385A8A.6070405@redhat.com> <4638AB55.20408@goop.org> <4638F9BE.8090508@zytor.com> <4638FC39.4010101@goop.org> <4638FE1B.9050901@zytor.com> <46390523.5010809@goop.org> <463909AF.9040205@zytor.com> <20070503045031.GA5794@in.ibm.com> <m1tzuuv24z.fsf@ebiederm.dsl.xmission.com> <86802c440705080941y69ddd5d6lab170c5f3967f148@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440705080941y69ddd5d6lab170c5f3967f148@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 09:41:09AM -0700, yhlu wrote:
> On 5/2/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> >Vivek Goyal <vgoyal@in.ibm.com> writes:
> >
> >> On Wed, May 02, 2007 at 02:59:11PM -0700, H. Peter Anvin wrote:
> >>> Jeremy Fitzhardinge wrote:
> >>> >
> >>> > So the bzImage structure is currently:
> >>> >
> >>> >    1. old-style boot sector
> >>> >    2. old-style boot info, followed by 0xaa55 at the end of the sector
> >>> >    3. the HdrS boot param block
> >>> >    4. setup.S boot code
> >>> >    5. the self-decompressing kernel
> >>> >
> 
> Eric,
> 
> With the latest change that make vmlinux to be elf64 and make bzImage
> do switch to 64bit long mode, the kernel started via kexec can not get
> VGA console. but the serial console works well. I wonder if the
> setup.S is skipped in bzImage via kexec path.
> 
> or i missed sth?
> 

Hi,

setup.S is never executed while doing kexec (unless somebody chooses to
do a real mode entry) and these patches don't change this beahviour.

Tomorrow I will test VGA behaviour on my machine. Are you using some
special frame buffer mode etc?

Thanks
Vivek
