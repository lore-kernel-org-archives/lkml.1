Return-Path: <linux-kernel-owner+w=401wt.eu-S1755726AbZCQI4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbZCQI4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 04:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbZCQI4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 04:56:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47819 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751911AbZCQI4V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 04:56:21 -0400
Date: Tue, 17 Mar 2009 08:57:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rocker Dude <life.does.rock@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Serial Flow Control
Message-ID: <20090317085714.54bcd51c@lxorguk.ukuu.org.uk>
In-Reply-To: <bc9165390903162234maedd4d0l7026d8f53a1859cc@mail.gmail.com>
References: <bc9165390903160912u79693a1dve975f559bfab103e@mail.gmail.com>
	<bc9165390903162233o48e02d94v6bb216e5d68d9e77@mail.gmail.com>
	<bc9165390903162234maedd4d0l7026d8f53a1859cc@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Mar 2009 11:04:36 +0530
Rocker Dude <life.does.rock@gmail.com> wrote:

> Hi All,
> 
> I am using a powerpc8548e custom hardware and testing flow control on
> it. I have cross-wired the RTS/CTS of the board with my host terminal.
> I find that when I am reading from the powerpc, it does not change the
> CTS signal when it is running out of buffers and hence it is dropping
> bytes.
> 
> I referred to something similar at http://lkml.org/lkml/2007/7/26/46.
> 
> Can anyone please tell me if this flow control needs to be done by the SW?

Flow control needs to be enabled by the user space software (if not
enabled already), managed by the line discipline and implemented by the
device driver (or automatically in hardware in some cases)

Basically; App "set CRTSCTS"
Ldisc: buffers full/not full logic for throttling
Driver: throttling events -> flow control, honour flow on write
