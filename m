Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbZBJHKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbZBJHKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 02:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbZBJHKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 02:10:32 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:61500 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbZBJHKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 02:10:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YUKxDZ6wkL5HROLBmYJ2yl9+pdrmkfxRC3RntvhPrgdLc3d8IXjTXvWOLIP0W2Y6es
         HMu8LyGTQPXlxVS3MN4opiLhhV9xESMe5FaF8FHUyQMLZKPxVOVFvmI1fczxtN2ySo7W
         sTGz49xVjk4sxthaJRVqfSse2dxbnwB6DZSfM=
MIME-Version: 1.0
In-Reply-To: <20090210142443.629E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20090210142443.629E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Date: Tue, 10 Feb 2009 08:10:29 +0100
Message-ID: <19f34abd0902092310g513fb776s2e4d37285c8fa7be@mail.gmail.com>
Subject: Re: [CRED bug?] 2.6.29-rc3 don't survive on stress workload
From: Vegard Nossum <vegard.nossum@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Howells <dhowells@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Content-Type: multipart/mixed; boundary=001636c59763a8a43204628b2e2a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636c59763a8a43204628b2e2a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On Tue, Feb 10, 2009 at 6:41 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Hi
>
> I periodically test kernel on stress workload.
> Unfortunately, recent kerenel don't survive >24H.
>
> It paniced with following stack.
> Do you have any suggestions?
>
> thanks!

That stack trace looks somewhat similar to the one in
http://lkml.org/lkml/2009/2/6/136

If this is reproducible, maybe a patch like the one attached can help
pinpoint it?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

--001636c59763a8a43204628b2e2a
Content-Type: application/octet-stream; name="kref-warn_on.patch"
Content-Disposition: attachment; filename="kref-warn_on.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fr08e1wq0

ZGlmZiAtLWdpdCBhL2xpYi9rcmVmLmMgYi9saWIva3JlZi5jCmluZGV4IDE1OTlkYmYuLmE1NDdh
ZDMgMTAwNjQ0Ci0tLSBhL2xpYi9rcmVmLmMKKysrIGIvbGliL2tyZWYuYwpAQCAtNDAsNyArNDAs
NyBAQCB2b2lkIGtyZWZfaW5pdChzdHJ1Y3Qga3JlZiAqa3JlZikKICAqLwogdm9pZCBrcmVmX2dl
dChzdHJ1Y3Qga3JlZiAqa3JlZikKIHsKLQlXQVJOX09OKCFhdG9taWNfcmVhZCgma3JlZi0+cmVm
Y291bnQpKTsKKwlXQVJOX09OKGF0b21pY19yZWFkKCZrcmVmLT5yZWZjb3VudCkgPD0gMCk7CiAJ
YXRvbWljX2luYygma3JlZi0+cmVmY291bnQpOwogCXNtcF9tYl9fYWZ0ZXJfYXRvbWljX2luYygp
OwogfQpAQCAtNjMsNyArNjMsNyBAQCBpbnQga3JlZl9wdXQoc3RydWN0IGtyZWYgKmtyZWYsIHZv
aWQgKCpyZWxlYXNlKShzdHJ1Y3Qga3JlZiAqa3JlZikpCiB7CiAJV0FSTl9PTihyZWxlYXNlID09
IE5VTEwpOwogCVdBUk5fT04ocmVsZWFzZSA9PSAodm9pZCAoKikoc3RydWN0IGtyZWYgKikpa2Zy
ZWUpOwotCVdBUk5fT04oIWF0b21pY19yZWFkKCZrcmVmLT5yZWZjb3VudCkpOworCVdBUk5fT04o
YXRvbWljX3JlYWQoJmtyZWYtPnJlZmNvdW50KSA8PSAwKTsKIAogCWlmIChhdG9taWNfZGVjX2Fu
ZF90ZXN0KCZrcmVmLT5yZWZjb3VudCkpIHsKIAkJcmVsZWFzZShrcmVmKTsK
--001636c59763a8a43204628b2e2a--
