Return-Path: <linux-kernel-owner+w=401wt.eu-S1759056AbYG2NGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759056AbYG2NGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 09:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbYG2NGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 09:06:23 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:44923 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbYG2NGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 09:06:22 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Darren Jenkins" <darrenrjenkins@gmail.com>
Cc: kernel Janitors <kernel-janitors@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs/fat/dir.c fix resource leak
References: <1217289813.9367.9.camel@localhost.localdomain>
	<87hca8alz6.fsf@devron.myhome.or.jp>
Date: Tue, 29 Jul 2008 22:06:18 +0900
In-Reply-To: <87hca8alz6.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Tue, 29 Jul 2008 21:55:25 +0900")
Message-ID: <87d4kwalh1.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

> "Darren Jenkins\" <darrenrjenkins@gmail.com> writes:
>
>> Coverity CID 2332 & 2333 RESOURCE_LEAK
>>
>> In fat_search_long() if fat_parse_long() returns a -ve value we return
>> without first freeing unicode and bufname.
>> This patch free's them on this error path.
>>
>> Signed-off-by: Darren Jenkins <darrenrjenkins@gmailcom>
>
> I'll apply to current code. Thanks.

I noticed this is false positive. bufname is not used anymore, and
fat_parse_long() never returns error after allocating unicode.

Instead, I'll apply this as cleanup.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
