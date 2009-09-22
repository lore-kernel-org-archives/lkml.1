Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbZIVSBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbZIVSBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 14:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756149AbZIVSBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 14:01:33 -0400
Received: from mail.perches.com ([173.55.12.10]:1093 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755503AbZIVSBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 14:01:33 -0400
Subject: Re: [PATCH 02/21] ceph: on-wire types
From: Joe Perches <joe@perches.com>
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, yehuda@newdream.net
In-Reply-To: <1253641129-28434-3-git-send-email-sage@newdream.net>
References: <1253641129-28434-1-git-send-email-sage@newdream.net>
	 <1253641129-28434-2-git-send-email-sage@newdream.net>
	 <1253641129-28434-3-git-send-email-sage@newdream.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Sep 2009 11:01:35 -0700
Message-Id: <1253642496.30020.58.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 10:38 -0700, Sage Weil wrote:
> These headers describe the types used to exchange messages between the
> Ceph client and various servers.  All types are little-endian and
> packed.
[]
> diff --git a/fs/ceph/ceph_fs.h b/fs/ceph/ceph_fs.h
> new file mode 100644
> index 0000000..15150fc
> --- /dev/null
> +++ b/fs/ceph/ceph_fs.h
[]
> +static inline __u32 frag_make(__u32 b, __u32 v)
> +{
> +	return (b << 24) |
> +		(v & (0xffffffu << (24-b)) & 0xffffffu);
> +}

frag_<foo> inlines might have a conflict with ipv6

> +static inline const char *ceph_mds_state_name(int s)
> +{
> +	switch (s) {
[]
> +	case CEPH_MDS_STATE_STOPPING:   return "up:stopping";
> +	default: return "";
> +	}
> +	return NULL;
> +}

inline?

It's probably better not to use inlines here
as the strings could be duplicated unnecessarily.

> +static inline const char *ceph_mds_op_name(int op)
> +{
> +	switch (op) {
[]
> +	default: return "???";
> +	}
> +}

inline again and a couple of different styles for these
switch blocks are used as well.  Perhaps remove the
default: case and use return ""; as the last statement.

> +static inline const char *ceph_cap_op_name(int op)
> +{
> +}
> +static inline const char *ceph_lease_op_name(int o)
> +static inline const char *ceph_snap_op_name(int o)
> --- /dev/null
> +++ b/fs/ceph/rados.h
> +static inline const char *ceph_osd_op_name(int op)

more inlines.

