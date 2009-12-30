Return-Path: <linux-kernel-owner+w=401wt.eu-S1752567AbZL3Kne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbZL3Kne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 05:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbZL3Knd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 05:43:33 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:48583 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbZL3Knc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 05:43:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PVUtWvdH6IHwrB+YqrGDrbmK5fIdh6F+Xokp8Or1zpYhWATWHY0fdms9VaLodYbVPM
         8cf/PhVmcbySRh44r7pgXEuUkORxW0X5K7r6lQ+SyfMQX4Yuc4FA4bklApKuMpmss1vE
         96JxKgFqzqFBSMDvCpTUMvHUQ6OOd7aNwGibU=
Date: Wed, 30 Dec 2009 02:43:25 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Vikram Dhillon <dhillonv10@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>
Subject: Re: [PATCH] [0/6] kfifo fixes/improvements
Message-ID: <20091230104325.GA2214@core.coreip.homeip.net>
References: <20091228145749.GD4994@basil.fritz.box>
 <1262016510.12656.25.camel@wall-e>
 <20091228172651.GE4994@basil.fritz.box>
 <1262030653.15368.37.camel@wall-e>
 <20091228204003.GH4994@basil.fritz.box>
 <1262076056.23095.21.camel@wall-e>
 <64D5262E-28CF-41E8-9425-F8C5DD0A2265@gmail.com>
 <ea6602020912291718n103694aft78ef15b65081a996@mail.gmail.com>
 <20091230020830.GA7049@core.coreip.homeip.net>
 <1262165390.4153.3.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262165390.4153.3.camel@wall-e>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 10:29:50AM +0100, Stefani Seibold wrote:
> 
> > On Tue, Dec 29, 2009 at 08:18:50PM -0500, Vikram Dhillon wrote:
> > > IMHO you can process elements rather than bytes, which is a good
> > > improvement, but then again its my opinion, if others don't like it
> > > then we can always change it :D
> > 
> > Right, I was not arguing against having a record-oriented interface, I
> > was questioning the utility of processing several records at a time.
> > Kfifo users that I have seen so far were working in a record-at-a-time
> > mode.
> > 
> 
> Fascinating, i get a lot of comments, but no one is trying the new macro
> base implementation. If someone would, this person would see, that is
> 100% compatible to the current one and absolut easy to use. Please try
> it first bevor argue and complain.
> 

I do not need to try the new behavior - you explained it quite well.
You changed the old API to allow processing multiple records at a time
and it does not quite work the way you want with Andi's patch. Now the
question is: when working with _records_ does anyone really want to
put/get more than 1 record at a time? My answer would be "no, most users
work with 1 record at a time". Thus your changes to the old API are not
needed.

-- 
Dmitry
