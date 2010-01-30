Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136Ab0A3WZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab0A3WZQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 17:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060Ab0A3WZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 17:25:15 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57567 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab0A3WZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 17:25:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] input: remove BKL from uinput open function
Date: Sat, 30 Jan 2010 22:57:09 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc5; KDE/4.3.2; x86_64; ; )
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1264800197-29523-1-git-send-email-cascardo@holoscopio.com> <201001300741.20954.arnd@arndb.de> <20100130072205.GA30378@core.coreip.homeip.net>
In-Reply-To: <20100130072205.GA30378@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001302257.09354.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18M5IBDsko1G5gLnohabo3XkpVNVhhxVkcNVil
 e05RPnUvpPPRJy3ZPf65hMSeWGFPqTLWJuOkMbSd9sCrobPgsK
 G3ICpB4FvTCna3KVWoC0w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 January 2010, Dmitry Torokhov wrote:
> On Sat, Jan 30, 2010 at 07:41:20AM +0100, Arnd Bergmann wrote:
> > The change looks good, but the same driver also uses the BKL in the
> > default_llseek function. It would be nice to get rid of that in the
> > same patch, e.g. by adding a ".llseek = generic_file_llseek," line
> > in the file_operations, or making it call nonseekable_open() if the
> > driver does not require seek to do anything.
> > 
> 
> I am afraid you mixed up the drivers, I don't see uinput implementing
> seek...

Sorry, I should have been clearer, but not implementing llseek
is the problem I was referring to: When a driver has no explicit
.llseek operation in its file operations and does not call
nonseekable_open from its open operation, the VFS layer will
implicitly use default_llseek, which takes the BKL. We're
in the process of changing drivers not to do this, one by one
so we can kill the BKL in the end.

	Arnd

