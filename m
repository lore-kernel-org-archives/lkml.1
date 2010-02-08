Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab0BHSnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 13:43:41 -0500
Received: from mail.elliptictech.com ([209.217.122.41]:51211 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752237Ab0BHSnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 13:43:40 -0500
Date: Mon, 8 Feb 2010 13:43:38 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Larry Homes <larr.homes@gmail.com>
Cc: andrew hendry <andrew.hendry@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Possible bug in insmod or the kernel?
Message-ID: <20100208184338.GA17495@emergent.ellipticsemi.com>
Mail-Followup-To: Larry Homes <larr.homes@gmail.com>,
	andrew hendry <andrew.hendry@gmail.com>,
	linux-kernel@vger.kernel.org
References: <45c77aec1002071056re61b8acg5f480f8ea83c68c@mail.gmail.com>
 <d45a3acc1002071414q318edea3m38f6d5ddbbd841bc@mail.gmail.com>
 <45c77aec1002081013q2b07cb7flbd827a977ed51d4c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45c77aec1002081013q2b07cb7flbd827a977ed51d4c@mail.gmail.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:13 Mon 08 Feb     , Larry Homes wrote:
> No, the problem is not that the quotes are showing. The problem is
> that as soon as it sees a space, it assumes the following is the next
> parameters name. So for example:
> 
> [root@myhost modules]# insmod hello3.ko name="john smith"
> insmod: error inserting 'hello3.ko': -1 Unknown symbol in module
> 
> [root@myhost modules]# insmod hello3.ko "name=john smith"
> insmod: error inserting 'hello3.ko': -1 Unknown symbol in module
> 
> In both cases, dmesg shows:
> 
> hello3: Unknown parameter `smith'
> 
> I looked at the params.c code and it seems like the above should work.

I'm not familiar with the code in question, but I suspect that it
expects to actually see the quotation marks in the parameter value, but
your shell is eating them.  Try

  insmod hello3.ko 'name="john smith"'

instead.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
