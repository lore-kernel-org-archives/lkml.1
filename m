Return-Path: <linux-kernel-owner+w=401wt.eu-S964976AbZLGUmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964976AbZLGUmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 15:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935224AbZLGUmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 15:42:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:32868 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935185AbZLGUmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 15:42:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=WAirf5ymVN/8bYE1bIvs3OCPVep5wy8Xs0z5ukOPDiMU1a4mZPVkzOBb0pUybRq+H4
         2uMN9Tot7rdEYoZGMUWsrm3XapYTxh9Qi78UNnyF2y1Q7ah96EBat6r/BBBkPqzec2vC
         pTkvygI6TKNMJoAikDk9zJfv0XSy9DQUiAswI=
Message-ID: <4B1D68AD.2090409@gmail.com>
Date: Mon, 07 Dec 2009 21:42:21 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091122 SUSE/3.0.0-9.1 Thunderbird/3.0
MIME-Version: 1.0
To: Thomas Hellstrom <thellstrom@vmware.com>
CC: Dave Airlie <airlied@redhat.com>, dri-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: DRM/ttm: Unreachable code in ttm_bo_add_ttm
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Stanse found unreachable code in ttm_bo_add_ttm:
http://decibel.fi.muni.cz/~xslaby/stanse/error.cgi?db=32&id=714#l238

Excerpt from there:
  230| case ttm_bo_type_user:
  231|  bo->ttm = ttm_tt_create(bdev, bo->num_pages << 12,
  232|     page_flags | (1 << 1),
  233|     glob->dummy_read_page);
  234|  if (bo->ttm == ((void *)0))
  235|   ret = -12;
  236|  break;
  237|
  238|  ret = ttm_tt_set_user(bo->ttm, get_current(),
     |This node is unreachable prev next
  239|          bo->buffer_start, bo->num_pages);
  240|  if (ret != 0)
  241|   ttm_tt_destroy(bo->ttm);
  242|  break;


regards,
-- 
js
