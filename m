Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbYIFSab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbYIFSab (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 14:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYIFSaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 14:30:23 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:13496 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbYIFSaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 14:30:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LJEnhZZqVynkMCs7rjjiYAPwgErKgnOf3Bb8ojLp7Y2dVIUue7vBfh8SorOr8RBdMq
         mgyeN3c0n52PwCueYokcVM/hHJ6BTGO7fBWUREGeGtMVqvy+7tOF4Z4KNNibfs9l7C4N
         yXP0iNvURO+0GDb6xWIJjwaNDN1nd5rWWd7DE=
Message-ID: <a36005b50809061130t1b510b7eu3f7336ebeef4f36b@mail.gmail.com>
Date: Sat, 6 Sep 2008 11:30:21 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: nice and hyperthreading on atom
Cc: "Phil Endecott" <phil_wueww_endecott@chezphil.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080906094248.5930911a@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220715811849@dmwebmail.dmwebmail.chezphil.org>
	 <20080906094248.5930911a@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 6, 2008 at 9:42 AM, Arjan van de Ven <arjan@infradead.org> wrote:
> As an OS one COULD decide to just not schedule the nice task at all,
> but then, especially on atom where HT has a high efficiency, your cpu
> is mostly idle ...

One thread being idle is even on Atom the right thing to do in some
situations.  If you have processes which, when HT is used, experience
high pressure on the common cache(s) then you should not schedule them
together.  We can theoretically find out whether this is the case
using the PMCs.  With perfmon2 hopefully on the horizon soon it might
actually be possible to automatically make these measurements.

There is another aspect I talked to Peter about already.  We really
want concurrent threat scheduling in some cases.  For the
implementation of helper threads you don't want two threads to be
scheduled independently, you want them to be scheduled on a HT pair.
Currently this isn't possible except by pinning them to fixed threads.
 We really want to have a new way to express this type of scheduling
(Peter, how did you call it?)
