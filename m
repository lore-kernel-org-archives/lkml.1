Return-Path: <linux-kernel-owner+w=401wt.eu-S933911AbYCSVud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933911AbYCSVud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932204AbYCSUT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:19:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:58862 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280AbYCSUT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:19:57 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: RE: MMC: Card detection through pin CD/DAT3 issue
To: Wappler Marcel <Marcel.Wappler@bridgeco.net>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Wed, 19 Mar 2008 00:08:36 +0100
References: <a8HRS-1KI-17@gated-at.bofh.it> <a8Ibj-2w0-17@gated-at.bofh.it> <a8J7c-4QO-1@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1Jbkv6-0003xh-IA@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18//CgbOkGCS8VMbgJrJbHZPwpy4DKfy7Tzyuo
 UXqeggSnSkNNhF5qCzYErtVEw6cXL5xoUZWC0ebr59iFT+SYvM
 eG+dbGbt+g3Wc94RST8Ng==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wappler Marcel <Marcel.Wappler@bridgeco.net> wrote:

> I have found this requirement in the SD host controller spec:
> "The card detect is active regardless of the SD Bus Power."
> 
> I wonder how the card should be able to pull up the CD/DAT3 Pad to VCC
> if its only VCC pad is not connected to VCC due to the fact that the host
> controller has switched off the cards power - any idea how this could be
> managed?

If the VCC pin is connected to 0 V, the "pullup" will pull down to 0 V.
If the controller reverses it's logic while VCC=0, it might work.

The controller might alternatively switch all pins (except the pullup) to
VCC, which would look to the card like switching all pins to 0V, but
detection by pullup would still work.

