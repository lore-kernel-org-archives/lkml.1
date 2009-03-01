Return-Path: <linux-kernel-owner+w=401wt.eu-S1758600AbZCAW4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbZCAW4t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 17:56:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756725AbZCAW4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 17:56:41 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:33057 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351AbZCAW4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 17:56:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=VyHKMYPxJY/AQFDTh4CP32lwPKlSej0TjRjECl9HeMJLR4cKWdjuDX1svOxNijBIki
         04fSLQxsMd4UXyTtAC/1qBqAQ6RfkDbl8057nRfgmlZElKvono08kWZ2AvBibj8JKGTG
         2ch72fGPwo/fE6a2Hp57dTTCNAWoL4V7h5nfQ=
Message-ID: <49AB12A7.10708@gmail.com>
Date: Sun, 01 Mar 2009 23:56:39 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: lp: too large subtraction on unsigned?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vi drivers/char/lp.c +705

note that count is unsigned, and we do the loop:

do {
	if (canwrite > 0) {
		...
		count -= written;
	}
	if (lf && canwrite <= 0) {
		...
		count--;
		...
	}
} while (count > 0 && (CONSOLE_LP_STRICT || written > 0));

Isn't this wrong?

Roel
