Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbZBBQJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbZBBQJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 11:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbZBBQJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 11:09:30 -0500
Received: from mail.parknet.ad.jp ([210.171.162.6]:57539 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbZBBQJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 11:09:29 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: msdos_format_name() bug?
References: <4987030D.1070907@gmail.com>
Date: Tue, 03 Feb 2009 01:09:24 +0900
In-Reply-To: <4987030D.1070907@gmail.com> (Roel Kluin's message of "Mon, 02
	Feb 2009 15:28:29 +0100")
Message-ID: <87iqnsq0qz.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin <roel.kluin@gmail.com> writes:

> in msdos_format_name(const unsigned char *name, int len, ...)
>
> name is the proposed name, len is its length.
>
>         while (c != '.' && len--)
>                 c = *name++;
>         if (c == '.') {
>                 while (walk - res < 8)
>                         *walk++ = ' ';
>                 while (len > 0 && walk - res < MSDOS_NAME) {
>
> Is the postfix decrement in the first loop correct, or should it be
> prefix? (isn't that one character too many?)
>
> If not, note that if the proposed name ends with a dot: e.g.
> 'myfile.' the first while loop iterates until the dot which ends
> the loop, but because of the postfix decrement len already is 0,
> so the third while loop won't start. Is that correct?

In the "myfile." case, it seems correct. It will provide "MYFILE     ".
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
