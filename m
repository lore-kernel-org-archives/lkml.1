Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbZK0Aed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbZK0Aed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 19:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbZK0Aed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 19:34:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:49319 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbZK0Aec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 19:34:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
Date: Fri, 27 Nov 2009 00:34:30 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Jarod Wilson <jarod@redhat.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, Mario Limonciello <superm1@ubuntu.com>,
       linux-input@vger.kernel.org, linux-media@vger.kernel.org,
       Janne Grunau <j@jannau.net>, Christoph Bartelmus <lirc@bartelmus.de>
References: <200910200956.33391.jarod@redhat.com> <4B0EFC30.80208@redhat.com> <m38wdsstsv.fsf@intrepid.localdomain>
In-Reply-To: <m38wdsstsv.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911270034.30957.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18Bxj2spHHk4n75VeR84LzUZ9d7ocBIelSjaSU
 mACGuna/H8NsLv/c7vRR7CXUMGXNB7+cBRONLdDmxx8623E7AP
 cez3kSPZCxXhgst8hHJsA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 November 2009 00:19:44 Krzysztof Halasa wrote:
> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> 
> > Why do you want to replace everything into a single shot?
> 
> Why not? It seems simpler to me. We need to change this anyway.

ioctls with a variable argument length are a pain for 32 bit
emulation and stuff like strace. You either need to encode
the variable length into the ioctl cmd, making it variable
as well, or use a pointer in the data structure, which requires
conversion.

Ideally, ioctl arguments have a constant layout, no pointers
and are at most 64 bits long.

	Arnd <><
