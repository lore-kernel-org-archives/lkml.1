Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab0BJQxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 11:53:25 -0500
Received: from londo.lunn.ch ([80.238.139.98]:34063 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681Ab0BJQxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 11:53:23 -0500
X-Greylist: delayed 1410 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Feb 2010 11:53:23 EST
Date: Wed, 10 Feb 2010 17:28:45 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: chris.nicholson@cnick.org.uk
Cc: gregkh@suse.de, andrew@lunn.ch, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org,
       Chris Nicholson <chris@localhost.localdomain>
Subject: Re: [PATCH] Staging: batman-adv: fix checkpatch.pl issues in
 hard-interface.c This is a patch to the hard-interface.c file that fixes
 up the checkpatch.pl issues Signed-off-by: Chris Nicholson
 <chris.nicholson@cnick.org.uk>
Message-ID: <20100210162845.GG2900@lunn.ch>
References: <1265569063-3973-1-git-send-email-chris.nicholson@cnick.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265569063-3973-1-git-send-email-chris.nicholson@cnick.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris

Thanks for the patch.

However i have some stylistic issues with the patch. You seem to like
right justification of wrapped lines. I much prefer left.

On Sun, Feb 07, 2010 at 06:57:43PM +0000, chris.nicholson@cnick.org.uk wrote:
> From: Chris Nicholson <chris@localhost.localdomain>
> 
> ---
>  drivers/staging/batman-adv/hard-interface.c |   40 +++++++++++++++++---------
>  1 files changed, 26 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/staging/batman-adv/hard-interface.c b/drivers/staging/batman-adv/hard-interface.c
> index 5ea35da..c4ed846 100644
> --- a/drivers/staging/batman-adv/hard-interface.c
> +++ b/drivers/staging/batman-adv/hard-interface.c
> @@ -87,9 +87,15 @@ static void check_known_mac_addr(uint8_t *addr)
>  			continue;
>  
>  		addr_to_string(mac_string, addr);
> -		debug_log(LOG_TYPE_WARN, "The newly added mac address (%s) already exists on: %s\n",
> -		          mac_string, batman_if->dev);
> -		debug_log(LOG_TYPE_WARN, "It is strongly recommended to keep mac addresses unique to avoid problems!\n");
> +		debug_log(LOG_TYPE_WARN, "The newly added mac address (%s) "
> +							"already exists on: "
> +							"%s\n",
> +							mac_string,
> +							batman_if->dev);
> +		debug_log(LOG_TYPE_WARN, "It is strongly recommended to "
> +							"keep mac addresses "
> +							"unique avoid problems!"
> +							"\n");

Here i would prefer

		debug_log(LOG_TYPE_WARN, "The newly added mac address (%s) "
			  "already exists on: %s\n",
			  mac_string, batman_if->dev);
		debug_log(LOG_TYPE_WARN, "It is strongly recommended to "
			  "keep mac addresses unique avoid problems!\n");


>  	}
>  	rcu_read_unlock();
>  }
> @@ -121,7 +127,8 @@ static int hardif_is_interface_up(char *dev)
>  	if ((!list_empty(&if_list)) &&
>  	    strncmp(((struct batman_if *)if_list.next)->dev, dev, IFNAMSIZ) &&
>  	    !(((struct batman_if *)if_list.next)->if_active == IF_ACTIVE) &&
> -	    !(((struct batman_if *)if_list.next)->if_active == IF_TO_BE_ACTIVATED) &&
> +	    !(((struct batman_if *)if_list.next)->if_active ==
> +							IF_TO_BE_ACTIVATED) &&
Here i would put:
	    !(((struct batman_if *)if_list.next)->if_active ==
	      IF_TO_BE_ACTIVATED) &&
       

>  	    (!main_if_was_up())) {
>  		rcu_read_unlock();
>  		goto end;
> @@ -172,7 +179,7 @@ void hardif_deactivate_interface(struct batman_if *batman_if)
>  	active_ifs--;
>  
>  	debug_log(LOG_TYPE_NOTICE, "Interface deactivated: %s\n",
> -	          batman_if->dev);
> +							batman_if->dev);

There is some tab/space issues here, but batman_if->dev); should be
under the LOG_

>  }
>  
>  /* (re)activate given interface. */
> @@ -236,7 +243,7 @@ static void hardif_activate_interface(struct batman_if *batman_if)
>  		set_main_if_addr(batman_if->net_dev->dev_addr);
>  
>  	debug_log(LOG_TYPE_NOTICE, "Interface activated: %s\n",
> -	          batman_if->dev);
> +							batman_if->dev);

Same comment as above.
  
[snip]

> @@ -400,8 +412,7 @@ int hardif_add_interface(char *dev, int if_num)
>  	return 1;
>  
>  out:
> -	if (batman_if->packet_buff)
> -		kfree(batman_if->packet_buff);
> +	kfree(batman_if->packet_buff);
>  	kfree(batman_if);
>  	kfree(dev);
>  	return -1;
> @@ -413,7 +424,7 @@ char hardif_get_active_if_num(void)

This has already been fixed in linux-next. The code is going through
quite a lot of changes at the moment as part of the cleanup needed to
get out of stating. So i suggest you look at linux-next and not so
much as the latest -rc kernel, which is now somewhat out of date.

Here is a patch of how I think it should look like. With this
patch, the linux-next version of hard-interface.c is checkpatch.pl
clean. Is there anything i have missed? I will add the appropriate
headers and send it to GregKH sometime soon with my next batch of
patches for staging.

Thanks
	Andrew

diff --git a/drivers/staging/batman-adv/hard-interface.c b/drivers/staging/batman-adv/hard-interface.c
index f8b1ba3..229b94e 100644
--- a/drivers/staging/batman-adv/hard-interface.c
+++ b/drivers/staging/batman-adv/hard-interface.c
@@ -83,9 +83,11 @@ static void check_known_mac_addr(uint8_t *addr)
 		if (!compare_orig(batman_if->net_dev->dev_addr, addr))
 			continue;
 
-		printk(KERN_WARNING "batman-adv:The newly added mac address (%pM) already exists on: %s\n",
+		printk(KERN_WARNING "batman-adv:The newly added mac address "
+		       "(%pM) already exists on: %s\n",
 		       addr, batman_if->dev);
-		printk(KERN_WARNING "batman-adv:It is strongly recommended to keep mac addresses unique to avoid problems!\n");
+		printk(KERN_WARNING "batman-adv:It is strongly recommended to "
+		       "keep mac addresses unique to avoid problems!\n");
 	}
 	rcu_read_unlock();
 }
@@ -117,7 +119,8 @@ static int hardif_is_interface_up(char *dev)
 	if ((!list_empty(&if_list)) &&
 	    strncmp(((struct batman_if *)if_list.next)->dev, dev, IFNAMSIZ) &&
 	    !(((struct batman_if *)if_list.next)->if_active == IF_ACTIVE) &&
-	    !(((struct batman_if *)if_list.next)->if_active == IF_TO_BE_ACTIVATED) &&
+	    !(((struct batman_if *)if_list.next)->if_active ==
+	      IF_TO_BE_ACTIVATED) &&
 	    (!main_if_was_up())) {
 		rcu_read_unlock();
 		goto end;
@@ -162,7 +165,7 @@ void hardif_deactivate_interface(struct batman_if *batman_if)
 	active_ifs--;
 
 	printk(KERN_INFO "batman-adv:Interface deactivated: %s\n",
-		  batman_if->dev);
+	       batman_if->dev);
 }
 
 /* (re)activate given interface. */
@@ -245,7 +248,8 @@ static int resize_orig(struct orig_node *orig_node, int if_num)
 	data_ptr = kmalloc((if_num + 1) * sizeof(TYPE_OF_WORD) * NUM_WORDS,
 			   GFP_ATOMIC);
 	if (!data_ptr) {
-		printk(KERN_ERR "batman-adv:Can't resize orig: out of memory\n");
+		printk(KERN_ERR "batman-adv:Can't resize orig: "
+		       "out of memory\n");
 		return -1;
 	}
 
@@ -256,7 +260,8 @@ static int resize_orig(struct orig_node *orig_node, int if_num)
 
 	data_ptr = kmalloc((if_num + 1) * sizeof(uint8_t), GFP_ATOMIC);
 	if (!data_ptr) {
-		printk(KERN_ERR "batman-adv:Can't resize orig: out of memory\n");
+		printk(KERN_ERR "batman-adv:Can't resize orig:"
+		       "out of memory\n");
 		return -1;
 	}
 
@@ -280,7 +285,8 @@ int hardif_add_interface(char *dev, int if_num)
 	batman_if = kmalloc(sizeof(struct batman_if), GFP_KERNEL);
 
 	if (!batman_if) {
-		printk(KERN_ERR "batman-adv:Can't add interface (%s): out of memory\n", dev);
+		printk(KERN_ERR "batman-adv:Can't add interface (%s):"
+		       "out of memory\n", dev);
 		return -1;
 	}
 
@@ -294,7 +300,8 @@ int hardif_add_interface(char *dev, int if_num)
 	batman_if->packet_buff = kmalloc(batman_if->packet_len, GFP_KERNEL);
 
 	if (!batman_if->packet_buff) {
-		printk(KERN_ERR "batman-adv:Can't add interface packet (%s): out of memory\n", dev);
+		printk(KERN_ERR "batman-adv:Can't add interface packet (%s):"
+		       "out of memory\n", dev);
 		goto out;
 	}
 
@@ -344,7 +351,9 @@ int hardif_add_interface(char *dev, int if_num)
 	spin_unlock_irqrestore(&orig_hash_lock, flags);
 
 	if (!hardif_is_interface_up(batman_if->dev))
-		printk(KERN_ERR "batman-adv:Not using interface %s (retrying later): interface not active\n", batman_if->dev);
+		printk(KERN_ERR "batman-adv:Not using interface %s "
+		       "(retrying later): interface not active\n",
+		       batman_if->dev);
 	else
 		hardif_activate_interface(batman_if);
 
@@ -505,7 +514,6 @@ err_free:
 
 }
 
-
 struct notifier_block hard_if_notifier = {
 	.notifier_call = hard_if_event,
 };

