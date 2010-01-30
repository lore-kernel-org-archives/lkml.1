Return-Path: <linux-kernel-owner+w=401wt.eu-S1752235Ab0A3HWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab0A3HWN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 02:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091Ab0A3HWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 02:22:11 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:52461 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab0A3HWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 02:22:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=D5feUkOowcdmtTHpQwRCR7Xt8aSnRFvAVXAUloSx9gSmkEj//7P5/+uOR5RNI3ibyk
         t40DAFeGffbarEcIO7Z9kaPUizbwyt429nz5KzyWpjx7UCyqWZ+2yzP0La5cHCYClhEi
         mBtj9ULMmCM4FTmEKJnWOZbn/1lmHo8DTM9cc=
Date: Fri, 29 Jan 2010 23:22:05 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: remove BKL from uinput open function
Message-ID: <20100130072205.GA30378@core.coreip.homeip.net>
References: <1264800197-29523-1-git-send-email-cascardo@holoscopio.com>
 <201001300741.20954.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001300741.20954.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 30, 2010 at 07:41:20AM +0100, Arnd Bergmann wrote:
> On Friday 29 January 2010, Thadeu Lima de Souza Cascardo wrote:
> > Commit 8702965848ed4bee27486a3e3d2ae34ebba6dd83 has push down the BKL
> > into uinput open function. However, there's nothing that needs locking
> > in there.
> > 
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> 
> The change looks good, but the same driver also uses the BKL in the
> default_llseek function. It would be nice to get rid of that in the
> same patch, e.g. by adding a ".llseek = generic_file_llseek," line
> in the file_operations, or making it call nonseekable_open() if the
> driver does not require seek to do anything.
> 

I am afraid you mixed up the drivers, I don't see uinput implementing
seek...

Thanks.

-- 
Dmitry
