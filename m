Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbYGKJCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbYGKJCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 05:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbYGKJCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 05:02:37 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:16170 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758085AbYGKJCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 05:02:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=qsUgy5ToIY76iwthaQzTyO2ejiY9iWTIaoNlUiQvYFNAn0WEm5FeSzcBDXMiJAjY0l
         4iewl6JmMMvlBGc1Jps3FhcN7y3cNbOWSe+LCErodkKhJz68r7pv8ZSrK/qePlosZdKD
         OODT1vgosXETTHhNww8SvDgOBbe23gwVzZZQE=
Message-ID: <b647ffbd0807110202o10ca65c7yf93d8b2146a05e33@mail.gmail.com>
Date: Fri, 11 Jul 2008 11:02:25 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: v2.6.26-rc9: kernel BUG at kernel/sched.c:5858!
Cc: Yanmin <yanmin_zhang@linux.intel.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Gautham R Shenoy" <ego@in.ibm.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>, miaox@cn.fujitsu.com,
       "Lai Jiangshan" <laijs@cn.fujitsu.com>, "Avi Kivity" <avi@qumranet.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0807102249t6b2e9e97l97bc5b22cc7709ef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_22681_13106492.1215766945078"
References: <20080710115954.GA3639@damson.getinternet.no>
	 <19f34abd0807100512y7fff3716r3ff37305e863f26@mail.gmail.com>
	 <b647ffbd0807100550l44fae9fate511dafbf87564a4@mail.gmail.com>
	 <19f34abd0807100604p70c2fec6geca65b2ba772dea@mail.gmail.com>
	 <b647ffbd0807100703q442a9825hb857c321452027e7@mail.gmail.com>
	 <19f34abd0807100716k35e937batb4059f99fe46731b@mail.gmail.com>
	 <19f34abd0807101249y24632b50h769a7af2c9514864@mail.gmail.com>
	 <b647ffbd0807101316o97fe6d4p5b2cbcda472f2ae1@mail.gmail.com>
	 <19f34abd0807102249t6b2e9e97l97bc5b22cc7709ef@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_22681_13106492.1215766945078
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Vegard,


regarding the first crash. Would you please run your test with the
following debugging patch and let me know its output?

The apperance of " * [ pid ] comm (name), orig_cpu() ... " means we
hit a problematic case (with Miao Xie's patch it shouldn't crash).

I see that you have CONFIG_SCHED_DEBUG=y so I'm also interested in
messages from sched_domain_debug() - "CPU# attaching ...". IOW, all
the kernel messages appearing while a cpu is going down and up.


TIA,


-- 
Best regards,
Dmitry Adamushko

------=_Part_22681_13106492.1215766945078
Content-Type: text/x-patch; name=hotplug-debug.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fiik7bna0
Content-Disposition: attachment; filename=hotplug-debug.patch

LS0tIGtlcm5lbC9zY2hlZC1vcmlnLmMJMjAwOC0wNy0xMCAxNTowODowMS4wMDAwMDAwMDAgKzAy
MDAKKysrIGtlcm5lbC9zY2hlZC5jCTIwMDgtMDctMTEgMTA6NTI6NDguMDAwMDAwMDAwICswMjAw
CkBAIC0yMDgxLDYgKzIwODEsNyBAQCBzdGF0aWMgaW50IHRyeV90b193YWtlX3VwKHN0cnVjdCB0
YXNrX3N0CiAJdW5zaWduZWQgbG9uZyBmbGFnczsKIAlsb25nIG9sZF9zdGF0ZTsKIAlzdHJ1Y3Qg
cnEgKnJxOworCWludCBvb3BzID0gMDsKIAogCWlmICghc2NoZWRfZmVhdChTWU5DX1dBS0VVUFMp
KQogCQlzeW5jID0gMDsKQEAgLTIxMDMsNiArMjEwNCwxMSBAQCBzdGF0aWMgaW50IHRyeV90b193
YWtlX3VwKHN0cnVjdCB0YXNrX3N0CiAJCWdvdG8gb3V0X2FjdGl2YXRlOwogCiAJY3B1ID0gcC0+
c2NoZWRfY2xhc3MtPnNlbGVjdF90YXNrX3JxKHAsIHN5bmMpOworCWlmICh1bmxpa2VseShjcHVf
aXNfb2ZmbGluZShjcHUpKSkgeworCQljcHUgPSBvcmlnX2NwdTsKKwkJb29wcyA9IDE7CisJfQor
CiAJaWYgKGNwdSAhPSBvcmlnX2NwdSkgewogCQlzZXRfdGFza19jcHUocCwgY3B1KTsKIAkJdGFz
a19ycV91bmxvY2socnEsICZmbGFncyk7CkBAIC0yMTU5LDYgKzIxNjUsMTAgQEAgb3V0X3J1bm5p
bmc6CiBvdXQ6CiAJdGFza19ycV91bmxvY2socnEsICZmbGFncyk7CiAKKwlpZiAob29wcykKKwkJ
cHJpbnRrKEtFUk5fRVJSICIgKiBbICVkIF0gY29tbSAoJXMpLCBvcmlnX2NwdSAoJWQpLCBkc3Rf
Y3B1ICglZCksIGNwdSAoJWQpXG4iLAorCQkJcC0+cGlkLCBwLT5jb21tLCBvcmlnX2NwdSwgY3B1
LCB0YXNrX2NwdShwKSk7CisKIAlyZXR1cm4gc3VjY2VzczsKIH0KIApAQCAtNTcxMiw2ICs1NzIy
LDEwIEBAIHN0YXRpYyBpbnQgX19taWdyYXRlX3Rhc2tfaXJxKHN0cnVjdCB0YXMKIAlsb2NhbF9p
cnFfZGlzYWJsZSgpOwogCXJldCA9IF9fbWlncmF0ZV90YXNrKHAsIHNyY19jcHUsIGRlc3RfY3B1
KTsKIAlsb2NhbF9pcnFfZW5hYmxlKCk7CisKKwlwcmludGsoS0VSTl9FUlIgIl9fbWlncmF0ZSgl
ZCAtLSAlcykgLT4gY3B1ICglZCkgPT0gcmV0ICglZClcbiIsCisJCXAtPnBpZCwgcC0+Y29tbSwg
ZGVzdF9jcHUsIHJldCk7CisKIAlyZXR1cm4gcmV0OwogfQogCkBAIC01ODY4LDYgKzU4ODIsNyBA
QCBzdGF0aWMgdm9pZCBtaWdyYXRlX2RlYWQodW5zaWduZWQgaW50IGRlCiAJICogZmluZS4KIAkg
Ki8KIAlzcGluX3VubG9ja19pcnEoJnJxLT5sb2NrKTsKKwlwcmludGsoS0VSTl9FUlIgIi0tLT4g
bWlncmF0ZV9kZWFkKCVkIC0tICVzKVxuIiwgcC0+cGlkLCBwLT5jb21tKTsKIAltb3ZlX3Rhc2tf
b2ZmX2RlYWRfY3B1KGRlYWRfY3B1LCBwKTsKIAlzcGluX2xvY2tfaXJxKCZycS0+bG9jayk7CiAK

------=_Part_22681_13106492.1215766945078--
