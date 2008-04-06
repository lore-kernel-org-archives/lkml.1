Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991AbYDFEae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbYDFEae (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 00:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbYDFEaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 00:30:25 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:48413 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbYDFEaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 00:30:25 -0400
Date: Sun, 6 Apr 2008 06:30:24 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Marc Perkel <mperkel@yahoo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: tee question [OT]
In-Reply-To: <96637.86039.qm@web52504.mail.re2.yahoo.com>
Message-ID: <alpine.LNX.1.10.0804060627140.30794@fbirervta.pbzchgretzou.qr>
References: <96637.86039.qm@web52504.mail.re2.yahoo.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2008-04-06 06:10, Marc Perkel wrote:
> Just wondering if any of you experts know how to do
> this. I want to take an imput stream and produce two
> output streams to feed into two different pipes.
>
> echo "1 2 3 4 5" | tee ...
> | cut -d \  -f -4 >> file1.txt
> | cut -d \  -f 1,2,5- >> file2.txt
>
> The idea being that file1.txt would get "1 2 3 4" and
> file2.txt would get "1 2 5"
>
> How do I do it? Tee wants a file as an argument and I
> want that file to be a process.
> Anyhow - I'm not very smart.

echo "1 2 3 4 5" | \
tee >(cut -d" " -f -4 >>file1.txt) |
tee >(cut something else >>topieces) |
       cut -d" " -f 1,2,5- >>file2.txt;
