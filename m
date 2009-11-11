Return-Path: <linux-kernel-owner+w=401wt.eu-S1759636AbZKKXgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbZKKXgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 18:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759576AbZKKXgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 18:36:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759559AbZKKXgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 18:36:45 -0500
Date: Wed, 11 Nov 2009 15:36:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       linux-kernel@vger.kernel.org, rubini@gnudd.com, gregkh@suse.de
Subject: Re: [PATCH 3/3] misc: use a proper range for minor number dynamic
 allocation
Message-Id: <20091111153632.944a255c.akpm@linux-foundation.org>
In-Reply-To: <4AF8B4FF.9050405@zytor.com>
References: <1257813017-28598-1-git-send-email-cascardo@holoscopio.com>
	<1257813017-28598-2-git-send-email-cascardo@holoscopio.com>
	<1257813017-28598-3-git-send-email-cascardo@holoscopio.com>
	<4AF8B4FF.9050405@zytor.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Nov 2009 16:34:07 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 11/09/2009 04:30 PM, Thadeu Lima de Souza Cascardo wrote:
> > The current dynamic allocation of minor number for misc devices has some
> > drawbacks.
> > 
> > First of all, the range for dynamic numbers include some statically
> > allocated numbers. It goes from 63 to 0, and we have numbers in the
> > range from 1 to 15 already allocated. Although, it gives priority to the
> > higher and not allocated numbers, we may end up in a situation where we
> > must reject registering a driver which got a static number because a
> > driver got its number with dynamic allocation. Considering fs/dlm/user.c
> > allocates as many misc devices as lockspaces are created, and that we
> > have more than 50 users around, it's not unreasonable to reach that
> > situation.
> > 
> > The proposed solution uses the not yet reserved range from 64 to 127. If
> > more devices are needed, we may push 64 to 16.
> > 
> 
> Again, why not push these up above 256?
> 

I merged this patch, but made a note-to-self that there are remaining
open issues..
