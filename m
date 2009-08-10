Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbZHJLLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbZHJLLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 07:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbZHJLLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 07:11:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:52165 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbZHJLLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 07:11:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=a6gZ28TzXgSnAZfogCVd6fZv1KXO2UBcAJxzTG7V1bpTbkYwDxvfPEr+AHEyNYxCiY
         lDWKKI4XMZ9fc/aMDDdZueWraan2iRRel2QuRoZyzMLJ9jevvruHDdotjP0+ZmyrmSmX
         G6/ZUe0kuyIGJvRn+tn/OHkBXYr8A+xIIH/TI=
Message-ID: <4A800068.7030401@gmail.com>
Date: Mon, 10 Aug 2009 13:11:36 +0200
From: Artur Skawina <art.08.09@gmail.com>
User-Agent: Thunderbird 2.0.0.22pre (X11/20090422)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: xterm loses data (pts regression?)
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
