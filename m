Return-Path: <linux-kernel-owner+w=401wt.eu-S1764201AbYFHL2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764201AbYFHL2c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 07:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757542AbYFHL2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 07:28:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:58380 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758936AbYFHL2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 07:28:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=Xed1LWYHbWPb7XQ+fXj/AOZxiQtzQaOPG0LQqeGg9272cba2z7/6jrlp4jB22lZleR
         mpHLe5WlStNg11ksckjSkbFod6CoBPUlkgtNlTCqc+AR6MdthpLjlVcvIJgNmdSKHGYU
         2ETvkzw1zVYz5ZX+fFy6MQ54i2Pv+7k3oi5tI=
Message-ID: <71bff3710806080428n18c8e56dwcda54c5c9460d265@mail.gmail.com>
Date: Sun, 8 Jun 2008 15:28:23 +0400
From: "Q (Igor Mammedov)" <niallain@gmail.com>
To: "Marcin Slusarz" <marcin.slusarz@gmail.com>
Subject: Re: [linux-cifs-client] [PATCH] cifs: fix oops on mount when CONFIG_CIFS_DFS_UPCALL is enabled
Cc: LKML <linux-kernel@vger.kernel.org>, "Steve French" <sfrench@samba.org>,
       linux-cifs-client@lists.samba.org, stable@kernel.org
In-Reply-To: <20080607190055.GA5726@joi>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_7364_17059574.1212924503648"
References: <20080607190055.GA5726@joi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_7364_17059574.1212924503648
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

A quick look trough cifs_mount and cifs_parse_mount_options functions shows
that mount will fail anyway with error EINVAL when 'data' = NULL.
May be moving NULL check at the beginning of function will be better
in this case.

------=_Part_7364_17059574.1212924503648
Content-Type: text/x-patch; name=0001-CIFS-Fix-OOPs-when-data-is-NULL.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fh7jvagt0
Content-Disposition: attachment;
 filename=0001-CIFS-Fix-OOPs-when-data-is-NULL.patch

RnJvbSA4M2Q1MjNkMTM1NTZlOTgyODNkMGZlMzQzOTQ4MTlmODMzNjhlZmIzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBxIDxxQHEtZGVza3RvcC4obm9uZSk+CkRhdGU6IFN1biwgOCBK
dW4gMjAwOCAwODoxNTowNyAtMDQwMApTdWJqZWN0OiBbUEFUQ0hdIFtDSUZTXSBGaXggT09QcyB3
aGVuICdkYXRhJyBpcyBOVUxMCgoKU2lnbmVkLW9mZi1ieTogbmlhbGxhaW5AZ21haWwuY29tIDxx
QHEtZGVza3RvcC4obm9uZSk+Ci0tLQogZnMvY2lmcy9jaWZzZnMuYyB8ICAgIDMgKysrCiAxIGZp
bGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9mcy9jaWZzL2NpZnNmcy5jIGIvZnMvY2lmcy9jaWZzZnMuYwppbmRleCBlOWY0ZWM3Li5hZWU2
YjlkIDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNmcy5jCisrKyBiL2ZzL2NpZnMvY2lmc2ZzLmMK
QEAgLTEwMiw2ICsxMDIsOSBAQCBjaWZzX3JlYWRfc3VwZXIoc3RydWN0IHN1cGVyX2Jsb2NrICpz
Yiwgdm9pZCAqZGF0YSwKICNlbmRpZgogCWludCByYyA9IDA7CiAKKwlpZiAoIWRhdGEpCisJCXJl
dHVybiAtRUlOVkFMOworCiAJLyogQkIgc2hvdWxkIHdlIG1ha2UgdGhpcyBjb250aW5nZW50IG9u
IG1vdW50IHBhcm0/ICovCiAJc2ItPnNfZmxhZ3MgfD0gTVNfTk9ESVJBVElNRSB8IE1TX05PQVRJ
TUU7CiAJc2ItPnNfZnNfaW5mbyA9IGt6YWxsb2Moc2l6ZW9mKHN0cnVjdCBjaWZzX3NiX2luZm8p
LCBHRlBfS0VSTkVMKTsKLS0gCjEuNS40LjMKCg==
------=_Part_7364_17059574.1212924503648--
