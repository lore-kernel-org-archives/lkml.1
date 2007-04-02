Return-Path: <linux-kernel-owner+w=401wt.eu-S934023AbXDBMyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934023AbXDBMyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 08:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934031AbXDBMyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 08:54:17 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:16299 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934023AbXDBMyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 08:54:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type;
        b=dHZz7oFcWhbt6py3BQU4BTJHsIoCz3aHKyA82fARCYNN7XfR/F0J1JfubXWEzIkIz8qRoLjg39lPANY2uQB3JqGaB6SdvHhcNx7zm+vfIM6g5ov8aso9piPoyafyhApoB85/U2Z0AaG65FrNa7eA6kzg5AHKkm04Dc/7dlnERHQ=
Message-ID: <416aa1ad0704020554u54ec3720oe99eba180ffa11eb@mail.gmail.com>
Date: Mon, 2 Apr 2007 18:24:15 +0530
From: "kalash nainwal" <kalash.nainwal@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] (re)register_binfmt returns with -EBUSY
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_28567_25256107.1175518455270"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_28567_25256107.1175518455270
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

When a binary format is unregistered and re-registered,
register_binfmt fails with -EBUSY. The reason is that
unregister_binfmt does not set fmt->next to NULL, and seeing
(fmt->next != NULL), register_binfmt fails with -EBUSY.

One can find his way around by explicitly setting fmt->next to NULL
after unregistering, but that is kind of unclean (one should better be
using only the interfaces, and not the interal members, isn't it?)

Attached one-liner can fix it (for 2.6.20).

Regards,
-Kalash


Signed-off-by: Kalash Nainwal <kalash.nainwal@gmail.com>

------=_Part_28567_25256107.1175518455270
Content-Type: application/octet-stream; name=lnx_binfmt.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f00wz46h
Content-Disposition: attachment; filename="lnx_binfmt.patch"

LS0tIGxpbnV4LTIuNi4yMC9mcy9leGVjLmMJMjAwNy0wMi0wNSAwMDoxNDo1NC4wMDAwMDAwMDAg
KzA1MzAKKysrIGxpbnV4LTIuNi4yMF9tb2RpZmllZC9mcy9leGVjLmMJMjAwNy0wNC0wMiAxNzo1
Njo1Ni4zNjkxMDUyNzIgKzA1MzAKQEAgLTEwMCw2ICsxMDAsNyBAQCBpbnQgdW5yZWdpc3Rlcl9i
aW5mbXQoc3RydWN0IGxpbnV4X2JpbmZtCiAJd2hpbGUgKCp0bXApIHsKIAkJaWYgKGZtdCA9PSAq
dG1wKSB7CiAJCQkqdG1wID0gZm10LT5uZXh0OworCQkJZm10LT5uZXh0ID0gTlVMTDsKIAkJCXdy
aXRlX3VubG9jaygmYmluZm10X2xvY2spOwogCQkJcmV0dXJuIDA7CiAJCX0K
------=_Part_28567_25256107.1175518455270--
