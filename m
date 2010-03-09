Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab0CIUGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 15:06:40 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:65435 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab0CIUGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 15:06:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: [PATCH 2/3] input: use input_mutex instead of BKL when opening input device
Date: Tue, 9 Mar 2010 21:06:35 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Kacur <jkacur@gmail.com>
References: <1268162386-2745-1-git-send-email-cascardo@holoscopio.com> <1268162386-2745-2-git-send-email-cascardo@holoscopio.com>
In-Reply-To: <1268162386-2745-2-git-send-email-cascardo@holoscopio.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201003092106.35740.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19+7PicW5mwUac1KLj+o3iwkVkhpkPmT6jxFVt
 cdDUmyoV8iZ2kjv1ebX1BtEroSGd4cbzBKX4X4RU5s0Ur0mtVK
 hXNPlabB+qtypnfxqYUFg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 March 2010, Thadeu Lima de Souza Cascardo wrote:
> There are three types of input character devices: mousedev, joydev and
> evdev. They all use the same major device and, then, their opening is
> multiplexed in input_open_file.
> 
> After the BKL pushdown, this multiplexing is protected by the BKL. But
> there's already a mutex used for adding and removing to the table
> indexed by input_open_file.
> 
> So, we use this mutex instead of the BKL. Since it will call the
> handlers' open function under the mutex, I've checked that the current
> functions do not call input_{un,}register_{handler,device}, which are
> the only other functions to take the mutex.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
