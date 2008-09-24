Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbYIXQVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbYIXQVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbYIXQVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:21:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751635AbYIXQVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:21:24 -0400
Date: Wed, 24 Sep 2008 09:20:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: sqazi@google.com (Salman Qazi), linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: mlock: Make the mlock system call interruptible by fatal
Message-Id: <20080924092040.d8407311.akpm@linux-foundation.org>
In-Reply-To: <20080924112255.64304a64@lxorguk.ukuu.org.uk>
References: <20080923224751.GA2790@google.com>
	<20080924112255.64304a64@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2008 11:22:55 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > > Can we do
> > >
> > >        return i ? i : -EINTR;
> > >
> > > in the usual fashion?
> > 
> > Fixed.
> 
> If its only interruptible by fatal signals why do we care what the return
> is ?
> 

For the immediate in-kernel caller.  __get_user_pages() took a ref on a
few pages which the caller needs to undo before doing anything else
(like processing the signal).

