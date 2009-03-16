Return-Path: <linux-kernel-owner+w=401wt.eu-S1759029AbZCPK4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759029AbZCPK4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 06:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755130AbZCPK4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 06:56:25 -0400
Received: from mail-ew0-f164.google.com ([209.85.219.164]:36456 "EHLO
	mail-ew0-f164.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173AbZCPK4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 06:56:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gHbmprFpLNQNTKsSLkt+fF+gf0nYGKqBTHW5Cx83s6F2YJfhiy4J9yxyNy8FUMBZ/k
         0ldgVORgmkgIdJikOE917/QZjo6IZqZHFNP2SWNxgykSM4pMsbwZRLe+xTGMo3nggMVD
         tB3H6v6cO0bP73KE9JXGlqUPUQUiaFpxhQSmQ=
Message-ID: <49BE3052.5080801@gmail.com>
Date: Mon, 16 Mar 2009 11:56:18 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Char: isicom, prolong tty reference holding
References: <1237199665-10675-1-git-send-email-jirislaby@gmail.com> <20090316105026.610a0b9a@lxorguk.ukuu.org.uk>
In-Reply-To: <20090316105026.610a0b9a@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.3.2009 11:50, Alan Cox wrote:
> On Mon, 16 Mar 2009 11:34:24 +0100
> Jiri Slaby<jirislaby@gmail.com>  wrote:
>
>> Hold the tty reference a bit longer in isicom_shutdown_port, because
>> we use it later in the function, so that it won't disappear in the
>> meantime.
>
> NAK - we do have a bug there but I don't think that is it.
>
> The tty_kref_get takes an additional reference so the tty_port_tty_set is
> fine, but we don't then drop the kref we took temporarily. I think we
> need this:

Hmm, but the tty_port_tty_set drops the reference, right?
