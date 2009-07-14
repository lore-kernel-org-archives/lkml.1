Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbZGNUZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbZGNUZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 16:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbZGNUZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 16:25:46 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:52189 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbZGNUZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 16:25:46 -0400
Date: Tue, 14 Jul 2009 22:25:45 +0200
From: Andreas Mohr <andi@lisas.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@osdl.org>, Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, dmitry.torokhov@gmail.com,
       dtor@mail.ru, linux-input@vger.kernel.org
Subject: Re: Support for synaptic touchscreen in HTC dream
Message-ID: <20090714202545.GA7707@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090714100634.GA4054@elf.ucw.cz>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> +       ts->snap_down[swapped] = -inactive_area_left;
> +       ts->snap_up[swapped] = max_x + inactive_area_right;
> +       ts->snap_down[!swapped] = -inactive_area_top;
> +       ts->snap_up[!swapped] = max_y + inactive_area_bottom;
> +       ts->snap_down_on[swapped] = snap_left_on;
> +       ts->snap_down_off[swapped] = snap_left_off;
> +       ts->snap_up_on[swapped] = max_x - snap_right_on;
> +       ts->snap_up_off[swapped] = max_x - snap_right_off;
> +       ts->snap_down_on[!swapped] = snap_top_on;
> +       ts->snap_down_off[!swapped] = snap_top_off;
> +       ts->snap_up_on[!swapped] = max_y - snap_bottom_on;
> +       ts->snap_up_off[!swapped] = max_y - snap_bottom_off;

Could this perhaps be represented by _one_ struct definition
and two representations of it, one for swapped and one for non-swapped case or so?
(although sometimes it´s reverted logic, might need more thought)
Sounds like an awful lot of repeated array calculations for no overly good reason
(unless gcc happens to fully optimize it into oblivion automatically).

Andreas Mohr
