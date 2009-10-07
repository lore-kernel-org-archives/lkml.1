Return-Path: <linux-kernel-owner+w=401wt.eu-S933150AbZJGULn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150AbZJGULn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 16:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759973AbZJGULm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 16:11:42 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:52073 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759972AbZJGULm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 16:11:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=HxqjzMTzap/4GUiILahIsaSq7ugdmQ3YIzz9NiF5g3jkL4B2276/63ZlMcSe0LZGe8
         Qj1yyMy+xtrl007JkhTVHJRg0INmOfnAdNTbOhvVKVafpzJ44y802307xIOSuvnDfzQN
         biY5BkQVSo6i5oqTVEgA/X2++OVwJHihciHDE=
Message-ID: <4ACCF5D5.7010505@gmail.com>
Date: Wed, 07 Oct 2009 22:11:01 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-2.7 Thunderbird/3.0b4
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: linux-kernel@vger.kernel.org, strakh@ispras.ru
Subject: Re: [PATCH 2/4] isicom: switch to the new tty_port_open helper
References: <20091007144455.14550.95003.stgit@localhost.localdomain> <20091007144621.14550.62068.stgit@localhost.localdomain>
In-Reply-To: <20091007144621.14550.62068.stgit@localhost.localdomain>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2009 04:46 PM, Alan Cox wrote:
> -	if (port->port.flags & ASYNC_INITIALIZED)
> -		return 0;
> -	if (tty_port_alloc_xmit_buf(&port->port) < 0)
> +	if (tty_port_alloc_xmit_buf(tport) < 0)

I think this won't work well with 1/4. ->activate is called with
port->port.mutex (the name in this context), but tty_port_alloc_xmit_buf
wants it again.
