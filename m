Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082Ab0A3HCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab0A3HCn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 02:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567Ab0A3HCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 02:02:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60628 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab0A3HCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 02:02:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: [PATCH] input: remove BKL from uinput open function
Date: Sat, 30 Jan 2010 07:41:20 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc5; KDE/4.3.2; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1264800197-29523-1-git-send-email-cascardo@holoscopio.com>
In-Reply-To: <1264800197-29523-1-git-send-email-cascardo@holoscopio.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201001300741.20954.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/M9R/ouzpGFrTPFtrn7vzv0Qxc/EEQv6Eb09o
 BZWLP4VZ3NsFL380/U54CAaO4KCIhqbrVArtLGGSOpgiyaHB4X
 Zzru+OCy8eAsPkCySvu/w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 January 2010, Thadeu Lima de Souza Cascardo wrote:
> Commit 8702965848ed4bee27486a3e3d2ae34ebba6dd83 has push down the BKL
> into uinput open function. However, there's nothing that needs locking
> in there.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

The change looks good, but the same driver also uses the BKL in the
default_llseek function. It would be nice to get rid of that in the
same patch, e.g. by adding a ".llseek = generic_file_llseek," line
in the file_operations, or making it call nonseekable_open() if the
driver does not require seek to do anything.

	Arnd
