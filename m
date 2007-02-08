Return-Path: <linux-kernel-owner+w=401wt.eu-S1423241AbXBHR3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423241AbXBHR3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 12:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423243AbXBHR3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 12:29:16 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:52698 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423237AbXBHR3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 12:29:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kO4T8/QfnIsPh0IVQsVY8b2PiiCY2vtw8CsfCASW23P1Ex/3WJIfRSZjm3j1vDb2aBstHs4N9D9p5iCJYU6COJMZ5y1jE2Bj/yMFTFmKSNueW5nrV8ozSZwveeAfretFxhlvRffuvwCCeSznjNAe5kfzqjYVcp2ZqObA0ui9zMg=
Message-ID: <d120d5000702080929r7016de12k292add26a0a72291@mail.gmail.com>
Date: Thu, 8 Feb 2007 12:29:12 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: Re: Network: convert network devices to use struct device instead of class_device
Cc: "Jeff Garzik" <jeff@garzik.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, "Greg KH" <greg@kroah.com>
In-Reply-To: <20070208074130.29df585f@oldman>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702080400.l1840lFd002314@hera.kernel.org>
	 <45CB1AE6.9020707@garzik.org> <20070208074130.29df585f@oldman>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/07, Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> On Thu, 08 Feb 2007 07:43:18 -0500
> Jeff Garzik <jeff@garzik.org> wrote:
>
> > Linux Kernel Mailing List wrote:
> > > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=43cb76d91ee85f579a69d42bc8efc08bac560278
> > > Commit:     43cb76d91ee85f579a69d42bc8efc08bac560278
> > > Parent:     2943ecf2ed32632473c06f1975db47a7aa98c10f
> > > Author:     Greg Kroah-Hartman <gregkh@suse.de>
> > > AuthorDate: Tue Apr 9 12:14:34 2002 -0700
> > > Committer:  Greg Kroah-Hartman <gregkh@suse.de>
> > > CommitDate: Wed Feb 7 10:37:11 2007 -0800
> > >
> > >     Network: convert network devices to use struct device instead of class_device
> > >
> > >     This lets the network core have the ability to handle suspend/resume
> > >     issues, if it wants to.
>
> It fixes a non-problem. I would like to see the network core suspend/resume
> proposal as well. Last time I examined doing network core suspend help,
> the problem was that the physical device suspend was called before the
> class device. It is not clear how this change would help.

If physical devices are registered before class devices then when
suspending class devices are naturally suspended first. It is still
not clear to me why we need to convert everythign to struct device, I
believe I've shown (with patches) that it is possible to integrate
struct class_device into PM framework and avoid reshuffling half of
the kernel code.

-- 
Dmitry
