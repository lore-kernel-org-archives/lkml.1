Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbZEYNfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbZEYNfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 09:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbZEYNe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 09:34:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52110 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751613AbZEYNe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 09:34:56 -0400
Date: Mon, 25 May 2009 14:36:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ramagudi Naziir <naziirr@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: serial device and fsync
Message-ID: <20090525143603.3a741658@lxorguk.ukuu.org.uk>
In-Reply-To: <dfb262380905250250w2d689b28i25edc3d492b09676@mail.gmail.com>
References: <dfb262380905250250w2d689b28i25edc3d492b09676@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 May 2009 12:50:22 +0300
Ramagudi Naziir <naziirr@gmail.com> wrote:

> Hi all,
> 
> I need to write(2) a certain character to a serial device (using the
> standard /dev/ttySx), and make sure it was transferred to the device
> before I continue. I tried fsync(2), but that failed (does fsync even
> apply to character devices or only block devices ?).

Block devices
> 
> Any idea ?

Most hardware UARTs actually can't do this but the kernel will do its
best. The POSIX interface you want is tcdrain(fd). Quite why POSIX didn't
use fsync is a very good question.
