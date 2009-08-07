Return-Path: <linux-kernel-owner+w=401wt.eu-S1757668AbZHGMNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668AbZHGMNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 08:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757164AbZHGMNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 08:13:51 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:52204 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbZHGMNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 08:13:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=xwQZV4bXs3wtHxMoOnjP/gAP/UgRGPP6UL5IGa+cOUOaHJluKrXYwNvgEzWZFr042v
         gkmafHBr5RpjfhVX4nQMGf+rWifuoLCZTO8sLba7bWb73FWMZOkw0ijmwnE2pTm91Tr0
         uf1Xnw+8xYBobz3YqeWxiRTTAHEocXRU4VmEo=
Date: Fri, 7 Aug 2009 14:13:42 +0200 (SAST)
From: Dan Carpenter <error27@gmail.com>
X-X-Sender: dcarpenter@bicker
To: isdn@linux-pingi.de
cc: linux-kernel@vger.kernel.org
Subject: mISDN: potential null dereference in dsp_cmx_send_member()
Message-ID: <alpine.DEB.2.00.0907171344471.12306@bicker>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am testing a source analysis tool (http://repo.or.cz/w/smatch.git) 
and it generates a warning in dsp_cmx_send_member().

The problem is that on line 1327 we verify that dsp->conf is non null but 
on line 1329 we assume that it is non null and dereference it without 
checking.

drivers/isdn/mISDN/dsp_cmx.c
  1327                  if (dsp->conf && dsp->conf->software && dsp->conf->hardware)
  1328                          tx_data_only = 1;
  1329                  if (dsp->conf->software && dsp->echo.hardware)
  1330                          tx_data_only = 1;

regards,
dan carpenter
