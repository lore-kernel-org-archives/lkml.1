Return-Path: <linux-kernel-owner+w=401wt.eu-S934186AbYBCIvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934186AbYBCIvy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 03:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbYBCIvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 03:51:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:54203 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484AbYBCIvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 03:51:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=PFvVZnal/n2mjLbrS07bgzcfVlpOeMXm849iv1kZYyeKkx1qaeN6yM9/uiC7L++YtjynTlAmg/3JahnwdvHhTJPVEcLWjSrEWJHHwPb2IcVYqoFJpievxjOa74Jgy6esxxKWoebltXbPwEVlC9aCJNUWzBy6+sp9jUuLQVlO5oM=
Message-ID: <eb3ff54b0802030051x604c991fwe11184e25d0a7550@mail.gmail.com>
Date: Sun, 3 Feb 2008 10:51:42 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: "David Miller" <davem@davemloft.net>, kaber@trash.net, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [NET_SCHED] Add #ifdef CONFIG_NET_EMATCH in net/sched/cls_flow.c (latest git broken build)
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_604_21545021.1202028702374"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_604_21545021.1202028702374
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
The 2.6 latest git build was broken when using the following
configuration options:
CONFIG_NET_EMATCH=n
CONFIG_NET_CLS_FLOW=y

with the following error:
net/sched/cls_flow.c: In function 'flow_dump':
net/sched/cls_flow.c:598: error: 'struct tcf_ematch_tree' has no
member named 'hdr'
make[2]: *** [net/sched/cls_flow.o] Error 1
make[1]: *** [net/sched] Error 2
make: *** [net] Error 2


see the recent post by Li Zefan:
  http://www.spinics.net/lists/netdev/msg54434.html

The reason for this crash is that struct tcf_ematch_tree (net/pkt_cls.h) is
empty when CONFIG_NET_EMATCH is not defined.

When CONFIG_NET_EMATCH is defined, the tcf_ematch_tree structure indeed holds
a struct tcf_ematch_tree_hdr (hdr) as flow_dump() expects.

This patch adds #ifdef CONFIG_NET_EMATCH in flow_dump to avoid this.

The patch was build against latest 2.6 git net tree.


Regards,
Rami Rosen


Signed-off-by: Rami Rosen <ramirose@gmail.com>

------=_Part_604_21545021.1202028702374
Content-Type: text/plain; name=patch.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fc7cqbw70
Content-Disposition: attachment; filename=patch.txt

ZGlmZiAtLWdpdCBhL25ldC9zY2hlZC9jbHNfZmxvdy5jIGIvbmV0L3NjaGVkL2Nsc19mbG93LmMK
aW5kZXggNWE3ZjZhMy4uOGQ3Njk4NiAxMDA2NDQKLS0tIGEvbmV0L3NjaGVkL2Nsc19mbG93LmMK
KysrIGIvbmV0L3NjaGVkL2Nsc19mbG93LmMKQEAgLTU5NCwxMSArNTk0LDExIEBAIHN0YXRpYyBp
bnQgZmxvd19kdW1wKHN0cnVjdCB0Y2ZfcHJvdG8gKnRwLCB1bnNpZ25lZCBsb25nIGZoLAogCiAJ
aWYgKHRjZl9leHRzX2R1bXAoc2tiLCAmZi0+ZXh0cywgJmZsb3dfZXh0X21hcCkgPCAwKQogCQln
b3RvIG5sYV9wdXRfZmFpbHVyZTsKLQorI2lmZGVmIENPTkZJR19ORVRfRU1BVENICiAJaWYgKGYt
PmVtYXRjaGVzLmhkci5ubWF0Y2hlcyAmJgogCSAgICB0Y2ZfZW1fdHJlZV9kdW1wKHNrYiwgJmYt
PmVtYXRjaGVzLCBUQ0FfRkxPV19FTUFUQ0hFUykgPCAwKQogCQlnb3RvIG5sYV9wdXRfZmFpbHVy
ZTsKLQorI2VuZGlmCiAJbmxhX25lc3RfZW5kKHNrYiwgbmVzdCk7CiAKIAlpZiAodGNmX2V4dHNf
ZHVtcF9zdGF0cyhza2IsICZmLT5leHRzLCAmZmxvd19leHRfbWFwKSA8IDApCg==
------=_Part_604_21545021.1202028702374--
