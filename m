Return-Path: <linux-kernel-owner+w=401wt.eu-S1754238Ab0AQRkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab0AQRkh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 12:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205Ab0AQRkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 12:40:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:60379 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab0AQRkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 12:40:36 -0500
Date: Sun, 17 Jan 2010 09:40:43 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Felix Rubinstein <felixru@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: /dev/mem implementation
Message-ID: <20100117094043.0483ee1a@infradead.org>
In-Reply-To: <af0693f01001170847r49083075hc538a42b6bcd65ab@mail.gmail.com>
References: <af0693f01001170847r49083075hc538a42b6bcd65ab@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jan 2010 18:47:10 +0200
Felix Rubinstein <felixru@gmail.com> wrote:

> I see the motivation to limit the access to DRAM from root account
> CONFIG_STRICT_DEVMEM by mmap'ing /dev/[k]mem but it's easily overruled
> by simple char driver and implementing mmap of it's own totally
> bypassing all limitations.
> 
> What do you think about it guy?
> Appreciate it.

the reason PAT bans parts of /dev/mem is simple: it is illegal to have
mapping aliases (different cachability) for the same physical page.
Normal kernel APIs take care of this for the normal case, but /dev/mem
would be a back door into that.
This is a hardware imposed requirement, and violating the rule can have
really nasty consequences... hence the PAT code just not allowing it.

If you feel that you have a valid use case where you really want do
muck with such memory, it might be a good idea to explain that
usecase....

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
