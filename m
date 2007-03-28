Return-Path: <linux-kernel-owner+w=401wt.eu-S965673AbXC1S46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965673AbXC1S46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 14:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965657AbXC1S45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 14:56:57 -0400
Received: from styx.suse.cz ([82.119.242.94]:52214 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965673AbXC1S44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 14:56:56 -0400
Date: Wed, 28 Mar 2007 20:49:32 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@mandriva.com>
Cc: =?ISO-8859-2?Q?Robert_=A6wi=EAcki?= <jagger@swiecki.net>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] DCCP: proper optlen checking in do_dccp_getsockopt()
Message-ID: <Pine.LNX.4.64.0703282045010.19566@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="336216065-759182622-1175107772=:19566"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--336216065-759182622-1175107772=:19566
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE

From: Jiri Kosina <jkosina@suse.cz>

DCCP: proper optlen checking in do_dccp_getsockopt()

Robert Swiecki discovered [1] a signedness bug in checking of
optlen in do_dccp_getsockopt(). This bug can allow user to
read parts of the kernel memory.

[1] http://www.securityfocus.com/archive/1/463934/30/0/threaded

Cc: Robert =A6wi=EAcki <jagger@swiecki.net>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

 net/dccp/proto.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index cf28c53..5239f26 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -575,7 +575,7 @@ static int do_dccp_getsockopt(struct sock *sk, int leve=
l, int optname,
 =09if (get_user(len, optlen))
 =09=09return -EFAULT;
=20
-=09if (len < sizeof(int))
+=09if (len < 1)
 =09=09return -EINVAL;
=20
 =09dp =3D dccp_sk(sk);
--336216065-759182622-1175107772=:19566--
