Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab0BCQwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 11:52:40 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56392
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757291Ab0BCQwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 11:52:37 -0500
Date: Wed, 03 Feb 2010 08:52:49 -0800 (PST)
Message-Id: <20100203.085249.98326242.davem@davemloft.net>
To: johny@asimco.com.cn
Cc: kuznet@ms2.inr.ac.ru, netdev@vger.kernel.org, jmorris@namei.org,
       kaber@coreworks.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27.7-9-pae #7 SMP 1/1] networking tcp: Writing tcp
 socket be atomic
From: David Miller <davem@davemloft.net>
In-Reply-To: <474C17045AA24E3F8519EE76BAB47439@JOHNYE1>
References: <474C17045AA24E3F8519EE76BAB47439@JOHNYE1>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Locking belongs inside of the application, not in the kernel.

As evidenced by the fact that you had to add new socket options, the
application needs to be modified anyways.

It's therefore just as easy to add the appropriate locking to the
sequences where the application writes over the TCP socket.  And
it avoids having to modify the kernel at all.
