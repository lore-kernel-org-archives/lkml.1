Return-Path: <linux-kernel-owner+w=401wt.eu-S1754946AbZG1QuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbZG1QuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbZG1QuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:50:04 -0400
Received: from nox.protox.org ([88.191.38.29]:53053 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940AbZG1QuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:50:03 -0400
Subject: ttm_mem_global
From: Jerome Glisse <glisse@freedesktop.org>
To: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas@shipmail.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
In-Reply-To: <4A66CFDE.9090705@shipmail.org>
References: <1245931298.13359.8.camel@localhost.localdomain>
	 <4A439D7D.9030401@shipmail.org>  <1248197676.2368.11.camel@localhost>
	 <1248199231.2368.17.camel@localhost> <1248204128.2368.20.camel@localhost>
	 <4A66CFDE.9090705@shipmail.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Jul 2009 18:48:44 +0200
Message-Id: <1248799724.2288.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 10:37 +0200, Thomas Hellström wrote:
> TTM has a device struct per device and an optional global struct that is 
> common for all devices and intended to be per subsystem.
> 
> The only subsystem currently having a global structure is the memory 
> accounting subsystem:
> struct ttm_mem_global

Thomas i don't think the way we init ttm_mem_global today make
it follow the 1 struct ttm_mem_global for everyone. I think it
should be initialized and refcounted by device struct.

So on first device creation a ttm_mem_global is created and
then anytime a new device is created the refcount of ttm_mem_global
is increased. This would mean some static global refcount inside
ttm_memory.c, maybe there is something similar to singleton in
the linux toolbox.

Thought ? Idea ?

Cheers,
Jerome

