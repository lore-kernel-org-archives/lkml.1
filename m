Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179Ab0CKQOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 11:14:44 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43619 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933136Ab0CKQOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 11:14:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Kx2uO/hFRIRr6MM5kLlSxUfav8y1G+Ezv+jmzDF6+DDBfrdIFKIOIdJk1AjN4fMpW/
         74b9dXy/6uAYe3gQ94fsfgY+p5dkjmBPf2H6gsfAsXggNeunmduXiHJrRF/EY/T9peoR
         zIJgesicnSwFu3bchvyP2gHRzX9p7gHeNYFko=
Date: Fri, 12 Mar 2010 00:17:51 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.34-rc1: rcu lockdep bug?
Message-ID: <20100311161751.GA3804@hack>
References: <2375c9f91003110205v1d7f00bfk89472cb11bd985d3@mail.gmail.com> <20100311134556.GA6344@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100311134556.GA6344@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 05:45:56AM -0800, Paul E. McKenney wrote:
>On Thu, Mar 11, 2010 at 06:05:38PM +0800, Américo Wang wrote:
>> Hello, Paul and Peter,
>> 
>> Attached is the lockdep warning that I triggered today.
>> 
>> I am not sure if this is a bug of rcu lockdep, because I am
>> testing my patch when this occurred. However, in the backtrace,
>> there is none of the functions that I touched, weird.
>> 
>> So, please help to check if this is a bug of rcu lockdep.
>
>This sort of thing is caused by acquiring the same lock with softirq
>(AKA BH) blocked and not, which can result in self-deadlock.
>
>There was such a bug in the RCU lockdep stuff in -tip, but it has long
>since been fixed.  If you were seeing that bug, rcu_do_batch() would
>be on the stack, which it does not appear to be.
>
>So does your patch involve the usbfs_mutex?  Or attempt to manipulate
>vfs/fs state from withing networking softirq/BH context?
>

Nope, it is a patch for netpoll, nothing related with usb, nor vfs.

Thanks much!

