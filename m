Return-Path: <linux-kernel-owner+w=401wt.eu-S964863AbZGQQAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964863AbZGQQAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 12:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964847AbZGQQAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 12:00:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55739 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964836AbZGQQAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 12:00:33 -0400
Date: Fri, 17 Jul 2009 17:01:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Harris <jeff_harris@kentrox.com>
Cc: alan@linux.intel.com, vapier@gentoo.org, adobriyan@gmail.com,
       linux-kernel@vger.kernel.org, Jeff Harris <jeff_harris@kentrox.com>
Subject: Re: [PATCH] tty: Fix tcdrain hang due to tty chars_in_buffer errors
Message-ID: <20090717170124.05881456@lxorguk.ukuu.org.uk>
In-Reply-To: <1247843274-7462-1-git-send-email-jeff_harris@kentrox.com>
References: <1247843274-7462-1-git-send-email-jeff_harris@kentrox.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jul 2009 11:07:54 -0400
Jeff Harris <jeff_harris@kentrox.com> wrote:

> If a tty driver's chars_in_buffer callback reports an error, the wait loop in

chars_in_buffer cannot report an error. It reports how many characters
are in the buffer.

> A process calling tcdrain will block indefinitely if it calls tcdrain when the
> device is disconnected.

Fix your chars_in_buffer. On a disconnect its quite reasonable to return
0, as they are not buffered any more.

Alan
