Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbYL3Noa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbYL3Noa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 08:44:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbYL3NoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 08:44:22 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59859 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752073AbYL3NoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 08:44:21 -0500
Date: Tue, 30 Dec 2008 13:44:27 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Joe Peterson <joe@skyrush.com>, LKML <linux-kernel@vger.kernel.org>,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [BUG?] tty doesn't handle ^D at cooked/non-cooked switching
 corner case
Message-ID: <20081230134427.003ff13a@lxorguk.ukuu.org.uk>
In-Reply-To: <20081230201932.128D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081230201932.128D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Dec 2008 21:00:23 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi tty expert,
> 
> Recently, ruby (scripting program language) developing group found
> that linux doesn't handle ^D properly at cooked/non-cooked switching
> corner case.

I don't believe the behaviour of input characters typed across that
boundary is defined by the standards at all. That said I think the
behaviour you expect is reasonable.

> They create following patch. is it right way?

You could recompute minimum in this case but zero is definitely
incorrect. I think what you would actually need to do is to extract out
the code just below do_it_again: which computes minimum and recompute it
properly.

Alan
