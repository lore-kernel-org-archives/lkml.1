Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbZCDXD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbZCDXD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 18:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbZCDXDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 18:03:50 -0500
Received: from rv-out-0506.google.com ([209.85.198.234]:8830 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbZCDXDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 18:03:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BAJffIrzTblzCPWo90yuOAhMGh7GcDAo4LspAxAAxCUB8MVDmt7ARnyFY7Y7zZa/pk
         Il9D+Btq9oor4ycb3oKbjhAp3hB6dsxXFid8bdjtEV+JRMFBRA4JHSxD5DNxHY77HpFz
         GPpIKBdHvu48rowx+9BLAJv4yGLoKtXk+BvpI=
MIME-Version: 1.0
In-Reply-To: <e9c3a7c20902121612q724d0931ifb70d559081f206d@mail.gmail.com>
References: <20090212.204840.124087545.nemoto@toshiba-tops.co.jp>
	 <1234441811-9628-1-git-send-email-thierry.reding@avionic-design.de>
	 <e9c3a7c20902121612q724d0931ifb70d559081f206d@mail.gmail.com>
Date: Wed, 4 Mar 2009 16:03:47 -0700
X-Google-Sender-Auth: 5b8bd875d9fd60cf
Message-ID: <e9c3a7c20903041503lb2f55fct3ec39f268e609317@mail.gmail.com>
Subject: Re: [PATCH v2] dmaengine: Fix oops on dmatest module unload.
From: Dan Williams <dan.j.williams@intel.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, haavard.skinnemoen@atmel.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 5:12 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Thu, Feb 12, 2009 at 5:30 AM, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
>> This patch fixes an oops that happens when the dmatest module is unloaded. The
>> dma_release_channel() function is called on channels that have already been
>> cleaned up (and therefore freed) with dmatest_cleanup_channel().
>>
>> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>
> Thanks, applied with Atsushi's ack.
>

...and now it is unapplied :-).  The problem with this patch is that
it releases the channel before dmatest is done with it.  'Cleanup'
followed by 'release' is the right order, just need to save ->chan
before it gets freed.

--
Dan
