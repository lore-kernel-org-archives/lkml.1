Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817Ab0AJLXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab0AJLXH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 06:23:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349Ab0AJLXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 06:23:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:32244 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab0AJLXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 06:23:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:cc:subject:references
         :in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=TVRs5FmE4O8E9arSCX/01HwJk5eZakvJ3roscVWLIJDxdowZosvwjGmV99fdKj2WDV
         RXfiagnZhPb05kFqqXsdipKPmgmtgZWjBjB/ioopfYoHW/ugM/zSc1+e+VlTR+lhnsg3
         OYlb67DYiAizbsj46Aym/BQEI7+XfmuruAnjo=
Message-ID: <4B49B895.1060507@gmail.com>
Date: Sun, 10 Jan 2010 12:23:01 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-16.1 Thunderbird/3.0
MIME-Version: 1.0
CC: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 1/1] Char: synclink, fix potential null dereference
References: <1263113518-6377-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1263113518-6377-1-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2010 09:51 AM, Jiri Slaby wrote:
> Stanse found a potential null dereference in mgsl_put_char and
> mgsl_write. There is a check for tty being NULL, but it is
> dereferenced earlier. Move the dereference after the check.
> 
> Also reorder mgsl_paranoia_check so that it makes sense:
> * check !tty
> * deref tty
> * check !info
> * deref info

Actually, this is wrong, .write and .put_char cannot be called with NULL
tty.

-- 
js
