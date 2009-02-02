Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbZBBO2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbZBBO2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 09:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbZBBO2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 09:28:34 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:31915 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbZBBO2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 09:28:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Aanclbh2Dv0i9NukZkqu/U99lLTtxwRzCICRAhqXZvyruL0kDP0mLvRr3fTLXXv8t1
         Ql0WXbtwq+TBVJ6tq6y3QbFgE/uXFMjl7XfxqjmnPeZwbCyQMKUwY1gMrXpXFkClDq4O
         GYTPaoHb0SMvvzfdOcDuxg6keNaTxDwE2uoEw=
Message-ID: <4987030D.1070907@gmail.com>
Date: Mon, 02 Feb 2009 15:28:29 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: hirofumi@mail.parknet.co.jp
CC: lkml <linux-kernel@vger.kernel.org>
Subject: msdos_format_name() bug?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in msdos_format_name(const unsigned char *name, int len, ...)

name is the proposed name, len is its length.

        while (c != '.' && len--)
                c = *name++;
        if (c == '.') {
                while (walk - res < 8)
                        *walk++ = ' ';
                while (len > 0 && walk - res < MSDOS_NAME) {

Is the postfix decrement in the first loop correct, or should it be
prefix? (isn't that one character too many?)

If not, note that if the proposed name ends with a dot: e.g.
'myfile.' the first while loop iterates until the dot which ends
the loop, but because of the postfix decrement len already is 0,
so the third while loop won't start. Is that correct?

Roel

