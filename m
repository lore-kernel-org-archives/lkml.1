Return-Path: <linux-kernel-owner+w=401wt.eu-S933824AbZJGUyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933824AbZJGUyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 16:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933637AbZJGUyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 16:54:07 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:58115 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933284AbZJGUyE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 16:54:04 -0400
MIME-Version: 1.0
In-Reply-To: <20091007203121.GA432@trillian.comsick.at>
References: <20091007175403.GA335@trillian.comsick.at> <9b2b86520910071246r393f2afvacaa4d8f544508a8@mail.gmail.com> 
	<ac3eb2510910071306r4ad6dc9btb7503bc3ab0ec815@mail.gmail.com> 
	<ac3eb2510910071312qe6ad45ep6c579a8393cc6b8e@mail.gmail.com> 
	<20091007203121.GA432@trillian.comsick.at>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 7 Oct 2009 22:53:12 +0200
Message-ID: <ac3eb2510910071353v3bbe5bc7lc41e184fbc1ff7ed@mail.gmail.com>
Subject: Re: [BUG] No ttyS0 - Strange udev 8250_pnp interaction
To: Michael Guntsche <mike@it-loops.com>
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-hotplug <linux-hotplug@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 7, 2009 at 22:31, Michael Guntsche <mike@it-loops.com> wrote:
> add      /module/8250_pnp (module)
> remove /devices/platform/serial8250/tty/ttyS0 (tty)
> add      /devices/pnp0/00:05/tty/ttyS0 (tty)

That's pretty odd, that the loading of a module removes pre-existing
devices created by other code, and creates new ones with the same name
and major/minor.

As Alan mentioned, we could serialize events which carry the the same
major/minor number, that should work around such behavior.

Thanks,
Kay
