Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbZGUQ5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbZGUQ5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbZGUQ5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:57:52 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:34137 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbZGUQ5v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:57:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=u5wpUAvbhHfFJSahfQHA+vMhJWyCbe0uy10Kaw6HX0NFga4wryZO2RLuRcAIY6ppPB
         8KS9cN/gup/b+IRx8U18EtL325U27nH7Us5R7sA/e59/bDUmH6Jjqb/KH8y77wcG9QOw
         hnMy/i77BO7gLT2lUp/zPhcOWmP5KVXuICdlo=
MIME-Version: 1.0
In-Reply-To: <20090721160333.96AA4D3D@kernel>
References: <20090721160333.96AA4D3D@kernel>
Date: Tue, 21 Jul 2009 18:57:50 +0200
Message-ID: <1158166a0907210957p6fb73ed7pc7f5bb9f9ad6eac2@mail.gmail.com>
Subject: Re: [RFC][PATCH] flexible array implementation
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       bblum@google.com, linux-kernel@vger.kernel.org, menage@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 6:03 PM, Dave Hansen<dave@linux.vnet.ibm.com> wrote:
> +static inline struct flex_array_part *
> +__fa_get_part(struct flex_array *fa, int part_nr, gfp_t flags)
> +{
> +       struct flex_array_part *part = NULL;
> +       if (part_nr > __nr_part_ptrs())
> +               return NULL;
> +       part = fa->parts[part_nr];
> +       if (!part) {
> +               part = kmalloc(FLEX_ARRAY_PART_SIZE, flags);
> +               if (!part)
> +                       return NULL;
> +               fa->parts[part_nr] = part;
> +       }
> +       return part;
> +}

This is far too big to be an inline.

--
vda
