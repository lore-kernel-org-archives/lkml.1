Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbYJ3O4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbYJ3O4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 10:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbYJ3O4C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 10:56:02 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56046 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755994AbYJ3O4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 10:56:00 -0400
Date: Thu, 30 Oct 2008 15:55:52 +0100
From: Pavel Machek <pavel@suse.cz>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] w35und: plug memory leak in wbsoft_tx()
Message-ID: <20081030145552.GA1528@ucw.cz>
References: <Pine.LNX.4.64.0810280014140.9821@melkki.cs.Helsinki.FI> <20081028193204.GI16452@elf.ucw.cz> <84144f020810281408g4adda06em5cd7a620bf837b53@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020810281408g4adda06em5cd7a620bf837b53@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-10-28 23:08:50, Pekka Enberg wrote:
> On Tue 2008-10-28 00:14:38, Pekka J Enberg wrote:
> >> From: Pekka Enberg <penberg@cs.helsinki.fi>
> >>
> >> There's no reason to duplicate the skb in wbsoft_tx() and leak GFP_ATOMIC
> >> memory as the contents are copied to ->TxBuffer in MdxTx() anyway before
> >> MLMESendFrame() returns.
> 
> On Tue, Oct 28, 2008 at 9:32 PM, Pavel Machek <pavel@suse.cz> wrote:
> > Acked-by: Pavel Machek <pavel@suse.cz>
> >
> > ...but I guess I should test the this after it hits the mainline...
> 
> For sure. I'm bit surprised no one noticed this before as it seems to
> be leaking memory for every transmitted frame...

Well, I'm not quite surprised.  I noticed the driver stops working
after a while, but at that point it was a small miracle that it worked
at all...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
