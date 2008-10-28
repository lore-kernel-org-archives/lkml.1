Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbYJ1XYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbYJ1XYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 19:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbYJ1XYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 19:24:39 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44550 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbYJ1XYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 19:24:38 -0400
To: ncunningham@crca.org.au
CC: miklos@szeredi.hu, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-reply-to: <1225235860.9661.42.camel@nigel-laptop> (message from Nigel
	Cunningham on Wed, 29 Oct 2008 10:17:40 +1100)
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for
	frozen	filesystems.
References: <1224886068.6478.21.camel@nigel-laptop>
	 <E1KuQ1J-0002Vw-9Q@pomaz-ex.szeredi.hu>
	 <1225106427.26724.5.camel@nigel-laptop> <200810271237.40049.rjw@sisk.pl>
	 <1225107607.26724.9.camel@nigel-laptop>
	 <E1KuRN4-0002gS-Hq@pomaz-ex.szeredi.hu>
	 <1225141168.26724.23.camel@nigel-laptop>
	 <E1KuZKt-0003jl-2N@pomaz-ex.szeredi.hu>
	 <1225145607.26724.54.camel@nigel-laptop>
	 <E1Kuv87-00064p-Lk@pomaz-ex.szeredi.hu>
	 <1225235054.9661.37.camel@nigel-laptop>
	 <E1Kuxk4-0006NT-Ie@pomaz-ex.szeredi.hu> <1225235860.9661.42.camel@nigel-laptop>
Message-Id: <E1KuxvH-0006Q0-Dy@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 29 Oct 2008 00:24:27 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008, Nigel Cunningham wrote:
> Remember, though, that we're only freezing fuse at the moment, and
> strictly one filesystem at a time. We can thus happily wait for the
> i_mutex taken by some other process to be released.

Not going to work: you need to wait for all requests to be finished,
but those might depend on some other fuse filesystem which has already
been frozen.

Miklos
