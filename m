Return-Path: <linux-kernel-owner+w=401wt.eu-S1755039AbYAHS3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039AbYAHS3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:29:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbYAHS25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:28:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:59276 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbYAHS24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:28:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Iy+em2Thbycp7YHGBUHguImWDgNd9VAAwgG61MeEidCN1BkMMwBYP6juWnCBXQuMndFIat7zMRq6ItfAbMEfsrusAamvQAy11kWPs3o4uI03tbhXwKeyYZEGrkeDj5Bt20oiH2eOAhOdnIQjyNOV+aKfZfMxREVLbO/kw0n7Bbk=
Date: Tue, 8 Jan 2008 19:29:54 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7] udf: replace loops coded with goto to real loops
Message-ID: <20080108182945.GA8106@joi>
References: <1199582513-7915-1-git-send-email-marcin.slusarz@gmail.com> <1199582513-7915-4-git-send-email-marcin.slusarz@gmail.com> <20080107144821.GK12589@duck.suse.cz> <20080107210955.GC22144@joi> <20080108101732.GB17794@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080108101732.GB17794@duck.suse.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 11:17:32AM +0100, Jan Kara wrote:
> On Mon 07-01-08 22:10:01, Marcin Slusarz wrote:
> > On Mon, Jan 07, 2008 at 03:48:21PM +0100, Jan Kara wrote:
> > > On Sun 06-01-08 02:21:50, marcin.slusarz@gmail.com wrote:
> > > > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > >   I'm not sure if this improves readability in general. If the code is
> > > really a loop in nature, then we should code it using do {} while but in
> > > case we loop back just in case of some error (as seems to be the case in
> > > udf_bitmap_new_block()), then IMHO goto is more explanative. So at least
> > > that one case I'd leave as is.
> > Why do you think it's an error?
>   There is code:
> 
>           if (!udf_clear_bit(bit, bh->b_data)) {
>                 udf_debug("bit already cleared for block %d\n", bit);
>                 goto repeat;
>         }
>   Now if this happens, it's a bug AFAICS because we have been searching for
> a free block and we hold s_alloc_mutex and hence we should not race with
> any other allocation.
Fine, I'll drop this part of patch.

Marcin
