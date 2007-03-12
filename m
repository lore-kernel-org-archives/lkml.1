Return-Path: <linux-kernel-owner+w=401wt.eu-S1030468AbXCLP7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030468AbXCLP7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 11:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030476AbXCLP7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 11:59:39 -0400
Received: from [81.2.110.250] ([81.2.110.250]:34727 "EHLO lxorguk.ukuu.org.uk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030468AbXCLP7i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 11:59:38 -0400
Date: Mon, 12 Mar 2007 17:03:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "=?UTF-8?B?TGx1w61z?= Batlle" <viriketo@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: bug in select() in linux
Message-ID: <20070312170302.3b7bdc0c@lxorguk.ukuu.org.uk>
In-Reply-To: <45219fb00703120802y78cf4dbds6e89b58de9d0f801@mail.gmail.com>
References: <45219fb00703120751t7acd1ae3kb77f556b81a87634@mail.gmail.com>
	<20070312160104.25d6b321@lxorguk.ukuu.org.uk>
	<45219fb00703120802y78cf4dbds6e89b58de9d0f801@mail.gmail.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2007 16:02:11 +0100
"Lluís Batlle" <viriketo@gmail.com> wrote:

> Oh, of course you're right. I was inside too much layers to think of
> the tcp protocol, and I did not pay attention to it.
> 
> Maybe something could be added to the manpage anyway.
> 
> The bad thing is that there's no way I can use a socket for writing
> using select() if that connection has been half-closed by the other
> end. Moo.

You can because the only case it will block is when the transmit queue is
partly or completely full which means that you will discover the
connection has been reset when the transmit triggers a reset.

If you wait on the FD concerned for write or exception events all should
work nicely.
