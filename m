Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab0BWGIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 01:08:30 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52828 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab0BWGI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 01:08:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=KDT2GfamGUckBZPYAU9QH2lO8yzl7ISmPRDjE1+/G6WtDRo1tjcYWd0a97W7uKgC1q
         1Wk4MrGa/dEDJihdAOoSdFzwHKP26ebc/yXZetIKFv+feDdn5kLRLZgjz9Po+O08bEMR
         TuR0zCCqj8hYvQz9EuWbtj7SiE+zLTTh0hWfQ=
Message-ID: <4B8370D5.1070302@garzik.org>
Date: Tue, 23 Feb 2010 01:08:21 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patch] atang tree: enhanced SSD detection
References: <201002211841.24936.bzolnier@gmail.com>
In-Reply-To: <201002211841.24936.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2010 12:41 PM, Bartlomiej Zolnierkiewicz wrote:
> DISCLAIMER: the fact of getting patches merged into atang tree means
> that from now on they will be getting updates for changes happening
> in atang tree and it should not be treated as an indication regarding
> decisions taken by 'upstream' kernel trees
>
>
> Improve SSD detection so block layer optimizations can be applied
> to many more SSD devices.
>
>
> The following changes since commit 17c619273d412ed7b6120e448f87b2329457fc90:
>    Bartlomiej Zolnierkiewicz (1):
>          pata_oldpiix: enable parallel scan
>
> are available in the git repository at:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/bart/misc.git atang-v4.7
>
> Bartlomiej Zolnierkiewicz (1):
>        libata: enhanced SSD detection
>
>   drivers/ata/libata-core.c |    3 +++
>   drivers/ata/libata-scsi.c |   18 ++++++++++--------
>   include/linux/libata.h    |    1 +
>   3 files changed, 14 insertions(+), 8 deletions(-)
>
>
> commit ded92e0d01fbb7f27bec7a35606847a2547e95e0
> Author: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Date:   Sun Feb 21 18:31:18 2010 +0100
>
>      libata: enhanced SSD detection
>
>      Many SSD devices predate or just don't implement non-rotational
>      media type advertisement through the word 217 of the id block so
>      check also the product id for 'SSD' substring to automatically
>      detect SSD devices and apply relevant block layer optimizations.
>
>      This is based on earlier Jeff Garzik's patch from April 2009:
>      http://lkml.org/lkml/2009/4/7/495
>
>      While at it:
>      - cleanup ata_scsi_dev_config() a bit
>
>      Tested with ASUS-PHISON SSD devices found in Asus Eee 901.
>
>      Cc: Jeff Garzik<jeff@garzik.org>
>      Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>

Yes, I agree we need something like this.  I will review for atang 
dependencies, and then make sure it gets applied to upstream.

The previous discussion of this approach concluded weakly with "poor 
heuristic", but a better approach did not materialize.

One question, though:  why did you drop ata_id_is_ssd() test?

	Jeff



