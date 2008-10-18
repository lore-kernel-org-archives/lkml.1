Return-Path: <linux-kernel-owner+w=401wt.eu-S1752051AbYJRIqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbYJRIqD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 04:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbYJRIpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 04:45:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:26166 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbYJRIpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 04:45:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=DRUKPAn8jTGl2Eft8HoCygxpqSexetKTxdrcrpn8rNJ6OLqN2q5DhZtdH2eHMZQFp+
         7Vemsj0p3rs1AYaDKH9txxQEKd8tlir5FXZrCOkByQh10dZl18GoSo/G0lh0po1rj6q8
         ieiCynDy+K9W18Dbo6SBTjZuS6c8pySo0LU4o=
Message-ID: <84144f020810180145p68a89d17y7609644f7b9d21bf@mail.gmail.com>
Date: Sat, 18 Oct 2008 11:45:50 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [Slightly off topic] A question about R/B trees.
Cc: "Chris Snook" <csnook@redhat.com>,
       "Maxim Levitsky" <maximlevitsky@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <87myh2jq55.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48F904FA.6090102@gmail.com> <48F90E96.3060800@redhat.com>
	 <87myh2jq55.fsf@basil.nowhere.org>
X-Google-Sender-Auth: 60272b46713ce876
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Sat, Oct 18, 2008 at 10:53 AM, Andi Kleen <andi@firstfloor.org> wrote:
> The problem with hash tables is that if they're big enough
> or if the rest of the workload is memory intensive
> each hit will be a cache miss. And you can do a lot of branch
> mispredicts in the time of a single cache miss.
>
> In general trees can be much better for cache usage, although
> it's generally better to use some tree that has nodes near
> the cache line size. Binary trees like RB are too small for that.

Right, but even for binary trees, you can get some of the benefits by
packing all the nodes in a slab cache of their own. That way many of
the neighboring nodes will share the same cache line if you're
allocating memory for the nodes in a top-down order. Of course, you
lose the benefits if the tree is updated a lot because you're back to
worst case allocation again.

                       Pekka
