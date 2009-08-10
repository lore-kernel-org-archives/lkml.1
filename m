Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbZHJP3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbZHJP3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 11:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755368AbZHJP3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 11:29:45 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:62166 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbZHJP3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 11:29:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=jq4xzEqt5s5bP3RNYNItuaMLXLi4rZ5xIhCYg0I9vvE6laE9JWib6zqz7hx3q/BzS1
         bWs++CL03NCvfVL/OKvUriarH993saIgy9fuHmqAktIz76WENfke8GidB/1XBzpmUnLN
         v+7RWlFsAwHFXwlKM5yfaQbLhl1F3DF2OBEEc=
Message-ID: <4A803CE7.20201@gmail.com>
Date: Mon, 10 Aug 2009 17:29:43 +0200
From: Artur Skawina <art.08.09@gmail.com>
User-Agent: Thunderbird 2.0.0.22pre (X11/20090422)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: xterm loses data (pty regression)
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[I have now gone back to 2.6.30.3 and the writes to the ptys do block there,
 so it's a recent regression.]

First noticed it after upgrading to v2.6.31-rc5-246-g90bc1a6, still happens
in rc5-381-g7b2aa03.
If i press ^S in an xterm the output stops as expected, but after a ^Q i see
only the newly written data, everything in between is lost. Like:

> for i in `seq 1 111`; do echo $i; sleep 1; done
1
2
3
4
9
10
11
12
13
^C

[typed ^S after '4', then ^Q after a few seconds]

If the command doing the printing exits before the ^Q is sent, i don't get
any reaction to the ^Q at all, which is why i initially thought it to be an
xserver bug.
Text consoles are unaffected, output resumes as it should.

artur
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

